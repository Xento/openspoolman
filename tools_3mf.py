import requests
import zipfile
import tempfile
import xml.etree.ElementTree as ET
import ftplib
import socket
import ssl
import os
import re
import time
from datetime import datetime
from config import PRINTER_CODE, PRINTER_IP
from urllib.parse import urlparse
from logger import log

class ImplicitFTP_TLS(ftplib.FTP_TLS):
  """
  FTP_TLS subclass that wraps sockets for implicit FTPS (port 990).
  Adapted from HA's ha-bambulab implementation.
  """
  def __init__(self, *args, **kwargs):
    super().__init__(*args, **kwargs)
    self._sock = None

  @property
  def sock(self):
    return self._sock

  @sock.setter
  def sock(self, value):
    if value is not None and not isinstance(value, ssl.SSLSocket):
      value = self.context.wrap_socket(value)
    self._sock = value

  def ntransfercmd(self, cmd, rest=None):
    conn, size = ftplib.FTP.ntransfercmd(self, cmd, rest)
    if self._prot_p:
      session = self.sock.session if isinstance(self.sock, ssl.SSLSocket) else None
      conn = self.context.wrap_socket(conn, server_hostname=self.host, session=session)
    return conn, size

def parse_ftp_listing(line):
    """Parse a line from an FTP LIST command."""
    parts = line.split(maxsplit=8)
    if len(parts) < 9:
        return None
    return {
        'permissions': parts[0],
        'links': int(parts[1]),
        'owner': parts[2],
        'group': parts[3],
        'size': int(parts[4]),
        'month': parts[5],
        'day': int(parts[6]),
        'time_or_year': parts[7],
        'name': parts[8]
    }

def get_base_name(filename):
    return filename.rsplit('.', 1)[0]

def filename_from_url(url: str | None) -> tuple[str | None, str | None]:
  if not url:
    return None, None
  parsed = urlparse(url)
  path = parsed.path or parsed.netloc
  if not path:
    return None, None
  return path, os.path.basename(path)

def parse_date(item):
    """Parse the date and time from the FTP listing item."""
    try:
        date_str = f"{item['month']} {item['day']} {item['time_or_year']}"
        return datetime.strptime(date_str, "%b %d %H:%M")
    except ValueError:
        return None

def get_filament_order(file, fallback_ids=None):
    filament_order = {}
    switch_count = 0

    for line in file:
        match_filament = re.match(r"^M620 S(\d+)[^;\r\n]*", line.decode("utf-8").strip())
        if match_filament:
            filament = int(match_filament.group(1))
            if filament not in filament_order and int(filament) != 255:
                filament_order[int(filament)] = switch_count
            switch_count += 1

    if len(filament_order) == 0:
       if fallback_ids:
          filament_order = {int(filament_id): idx for idx, filament_id in enumerate(fallback_ids)}
       else:
          filament_order = {1:0}

    return filament_order

def download3mfFromCloud(url, destFile):
  log("Downloading 3MF file from cloud...")
  # Download the file and save it to the temporary file
  response = requests.get(url)
  response.raise_for_status()
  destFile.write(response.content)

def ensure_ftps_connection(ftp_host, ftp_user, ftp_pass, connect_retries, timeout=15):
  """Create an implicit FTPS connection with retries."""
  context = ssl.create_default_context()
  context.check_hostname = False
  context.verify_mode = ssl.CERT_NONE

  for attempt in range(1, connect_retries + 1):
    ftp = ImplicitFTP_TLS(context=context, timeout=timeout)
    try:
      log(f"[DEBUG] FTP connection check ({attempt}/{connect_retries})...")
      ftp.connect(host=ftp_host, port=990, timeout=timeout)
      ftp.login(user=ftp_user, passwd=ftp_pass)
      ftp.prot_p()
      return ftp
    except tuple(list(ftplib.all_errors) + [socket.timeout]) as e:
      if attempt < connect_retries:
        log(f"[WARNING] FTP connection failed ({e}). Retrying in 5s...")
        time.sleep(5)
      else:
        log(f"[ERROR] Could not establish FTP connection after {connect_retries} attempts.")
      try:
        ftp.close()
      except Exception:
        pass
  return None

def download3mfFromFTP(filename, destFile):
  log("Downloading 3MF file from FTP...")
  ftp_host = PRINTER_IP
  ftp_user = "bblp"
  ftp_pass = PRINTER_CODE
  local_path = destFile.name
  base_name = os.path.basename(filename).lstrip("/")
  search_paths = ["/cache/", "/", "/sdcard/"]

  filenames_to_try = []
  if base_name.endswith(".3mf"):
    filenames_to_try.append(base_name)
  else:
    filenames_to_try.append(f"{base_name}.3mf")
    filenames_to_try.append(f"{base_name}.gcode.3mf")
  if base_name and base_name not in filenames_to_try:
    filenames_to_try.insert(0, base_name)

  max_retries = 6
  not_found_seen = False
  connect_retries = 3
  ftp = ensure_ftps_connection(ftp_host, ftp_user, ftp_pass, connect_retries)
  if ftp is None:
    return False

  def attempt_single_download(path_prefix, name):
    remote_path = f"{path_prefix}{name.lstrip('/')}"
    log(f"[DEBUG] Attempting file download: {remote_path}")
    expected_size = None
    try:
      expected_size = int(ftp.size(remote_path))
      log(f"[DEBUG] Remote size for {remote_path}: {expected_size} bytes")
    except Exception as e:
      log(f"[WARNING] Could not fetch size for {remote_path}: {e}")
    try:
      with open(local_path, "wb") as f:
        ftp.retrbinary(f"RETR {remote_path}", f.write)
    except Exception:
      try:
        if os.path.exists(local_path):
          os.remove(local_path)
      except Exception:
        pass
      raise
    if expected_size is not None:
      try:
        local_size = os.path.getsize(local_path)
        if local_size != expected_size:
          log(f"[WARNING] Downloaded size mismatch for {remote_path}: local {local_size} vs remote {expected_size}")
          try:
            os.remove(local_path)
          except Exception:
            pass
          return False
      except Exception:
        pass
    return True

  def find_latest_file(search_paths_inner, extensions):
    latest_path = None
    latest_time = None
    for path in search_paths_inner:
      try:
        entries = []
        def parse_line(line):
          pattern_with_time = r'^\\S+\\s+\\d+\\s+\\S+\\s+\\S+\\s+\\d+\\s+(\\S+\\s+\\d+\\s+\\d+:\\d+)\\s+(.+)$'
          pattern_with_year = r'^\\S+\\s+\\d+\\s+\\S+\\s+\\S+\\s+\\d+\\s+(\\S+\\s+\\d+\\s+\\d{4})\\s+(.+)$'
          m = re.match(pattern_with_time, line)
          ts = None
          fname = None
          if m:
            ts_str, fname = m.groups()
            try:
              ts = datetime.strptime(ts_str, "%b %d %H:%M").replace(year=datetime.now().year)
            except Exception:
              ts = None
          else:
            m = re.match(pattern_with_year, line)
            if m:
              ts_str, fname = m.groups()
              try:
                ts = datetime.strptime(ts_str, "%b %d %Y")
              except Exception:
                ts = None
          if fname:
            _, ext = os.path.splitext(fname)
            if ext in extensions:
              entries.append((ts, f"{path}{fname}"))
        ftp.retrlines(f"LIST {path}", parse_line)
        for ts, pth in entries:
          if ts is None:
            continue
          if latest_time is None or ts > latest_time:
            latest_time = ts
            latest_path = pth
      except Exception:
        log(f"[ERROR] Could not LIST path {path}")
    return latest_path

  try:
    attempt = 1
    while attempt <= max_retries:
      tried_any = False
      for candidate in filenames_to_try:
        for path_prefix in search_paths:
          try:
            tried_any = True
            log(f"[DEBUG] Attempt {attempt}: Starting download of {candidate} via {path_prefix}...")
            if attempt_single_download(path_prefix, candidate):
              log("[DEBUG] File successfully downloaded!")
              return True
          except ftplib.error_perm as e:
            message = str(e)
            lowered = message.lower()
            if message.startswith("550") or "denied" in lowered:
              not_found_seen = True
              continue
            log(f"[ERROR] Fatal FTP permission error: {message}")
            return False
          except tuple(list(ftplib.all_errors) + [socket.timeout]) as e:
            log(f"[WARNING] FTP connection error ({e}). Reconnecting...")
            try:
              ftp.close()
            except Exception:
              pass
            ftp = ensure_ftps_connection(ftp_host, ftp_user, ftp_pass, connect_retries)
            if ftp is None:
              return False
            continue
      if not tried_any:
        break
      if attempt < max_retries:
        log(f"[WARNING] Transient FTP error. Retrying in 5s...")
        time.sleep(5)
      attempt += 1

    latest = find_latest_file(search_paths, [".3mf"])
    if latest:
      log(f"[DEBUG] Falling back to latest .3mf: {latest}")
      expected_size = None
      try:
        expected_size = int(ftp.size(latest))
        log(f"[DEBUG] Remote size for fallback {latest}: {expected_size} bytes")
      except Exception as e:
        log(f"[WARNING] Could not fetch size for fallback {latest}: {e}")
      try:
        with open(local_path, "wb") as f:
          ftp.retrbinary(f"RETR {latest}", f.write)
        if expected_size is not None:
          try:
            local_size = os.path.getsize(local_path)
            if local_size != expected_size:
              log(f"[WARNING] Downloaded size mismatch for fallback {latest}: local {local_size} vs remote {expected_size}")
              try:
                os.remove(local_path)
              except Exception:
                pass
              return False
          except Exception:
            pass
        log("[DEBUG] File successfully downloaded via fallback.")
        return True
      except Exception as e:
        try:
          if os.path.exists(local_path):
            os.remove(local_path)
        except Exception:
          pass
        log(f"[ERROR] Fallback download failed for {latest}: {e}")
  finally:
    if ftp is not None:
      try:
        ftp.close()
      except Exception:
        pass

  if not_found_seen:
    log("[ERROR] File not found after max retries.")
    list_conn = ensure_ftps_connection(ftp_host, ftp_user, ftp_pass, connect_retries)
    if list_conn:
      try:
        list_path = "/"
        log(f"[DEBUG] Listing found printer files in {list_path} directory")
        try:
          listing = list_conn.nlst(list_path)
          log(f"[DEBUG] Directory Listing ({list_path}): {listing}")
        except Exception:
          log(f"[ERROR] Could not retrieve directory listing for {list_path}.")
      finally:
        try:
          list_conn.close()
        except Exception:
          pass
  return False

def download3mfFromLocalFilesystem(path, destFile):
  with open(path, "rb") as src_file:
    destFile.write(src_file.read())

def getMetaDataFrom3mf(url):
  """
  Download a 3MF file from a URL, unzip it, and parse filament usage.

  Args:
      url (str): URL to the 3MF file.

  Returns:
      list[dict]: List of dictionaries with `tray_info_idx` and `used_g`.
  """
  temp_file_name = None
  try:
    metadata = {}

    filepath, filename = filename_from_url(url)
    # Create a temporary file (delete_on_close is only available in newer Python versions)
    try:
      temp_file = tempfile.NamedTemporaryFile(delete_on_close=False, delete=False, suffix=".3mf")
    except TypeError:
      temp_file = tempfile.NamedTemporaryFile(delete=False, suffix=".3mf")
    with temp_file:
      temp_file_name = temp_file.name
      
      if url.startswith("http"):
        download3mfFromCloud(url, temp_file)
      elif url.startswith("local:"):
        download3mfFromLocalFilesystem(url.replace("local:", ""), temp_file)
      elif url.startswith(("file://", "ftp://", "ftps://")):
        file_path = filepath
        if not filename:
          filename = url.rpartition('/')[-1]
        download3mfFromFTP(filename, temp_file)
      else:
        download3mfFromFTP(url.rpartition('/')[-1], temp_file) # Pull just filename to clear out any unexpected paths
      
      temp_file.close()
      metadata["model_path"] = url

      metadata["file"] = filename or url

      log(f"3MF file downloaded and saved as {temp_file_name}.")

      # Unzip the 3MF file
      with zipfile.ZipFile(temp_file_name, 'r') as z:
        # Check for the Metadata/slice_info.config file
        slice_info_path = "Metadata/slice_info.config"
        if slice_info_path in z.namelist():
          with z.open(slice_info_path) as slice_info_file:
            # Parse the XML content of the file
            tree = ET.parse(slice_info_file)
            root = tree.getroot()

            # Extract id and used_g from each filament
            """
            <?xml version="1.0" encoding="UTF-8"?>
            <config>
              <header>
                <header_item key="X-BBL-Client-Type" value="slicer"/>
                <header_item key="X-BBL-Client-Version" value="01.10.01.50"/>
              </header>
              <plate>
                <metadata key="index" value="1"/>
                <metadata key="printer_model_id" value="N2S"/>
                <metadata key="nozzle_diameters" value="0.4"/>
                <metadata key="timelapse_type" value="0"/>
                <metadata key="prediction" value="5450"/>
                <metadata key="weight" value="26.91"/>
                <metadata key="outside" value="false"/>
                <metadata key="support_used" value="false"/>
                <metadata key="label_object_enabled" value="true"/>
                <object identify_id="930" name="FILENAME.3mf" skipped="false" />
                <object identify_id="1030" name="FILENAME.3mf" skipped="false" />
                <object identify_id="1130" name="FILENAME.3mf" skipped="false" />
                <object identify_id="1230" name="FILENAME.3mf" skipped="false" />
                <object identify_id="1330" name="FILENAME.3mf" skipped="false" />
                <object identify_id="1430" name="FILENAME.3mf" skipped="false" />
                <object identify_id="1530" name="FILENAME.3mf" skipped="false" />
                <object identify_id="1630" name="FILENAME.3mf" skipped="false" />
                <object identify_id="1730" name="FILENAME.3mf" skipped="false" />
                <object identify_id="1830" name="FILENAME.3mf" skipped="false" />
                <object identify_id="1930" name="FILENAME.3mf" skipped="false" />
                <object identify_id="2030" name="FILENAME.3mf" skipped="false" />
                <object identify_id="2130" name="FILENAME.3mf" skipped="false" />
                <object identify_id="2230" name="FILENAME.3mf" skipped="false" />
                <filament id="1" tray_info_idx="GFL99" type="PLA" color="#0DFF00" used_m="6.79" used_g="20.26" />
                <filament id="2" tray_info_idx="GFL99" type="PLA" color="#000000" used_m="0.72" used_g="2.15" />
                <filament id="6" tray_info_idx="GFL99" type="PLA" color="#0DFF00" used_m="1.20" used_g="3.58" />
                <filament id="7" tray_info_idx="GFL99" type="PLA" color="#000000" used_m="0.31" used_g="0.92" />
                <warning msg="bed_temperature_too_high_than_filament" level="1" error_code ="1000C001"  />
              </plate>
            </config>
            """
            
            for meta in root.findall(".//plate/metadata"):
              if meta.attrib.get("key") == "index":
                  metadata["plateID"] = meta.attrib.get("value", "")

            usage = {}
            filaments= {}
            filament_id_order = []
            for plate in root.findall(".//plate"):
              for filament in plate.findall(".//filament"):
                used_g = filament.attrib.get("used_g")
                filament_raw = filament.attrib.get("id")
                try:
                  filament_id = int(filament_raw)
                except (TypeError, ValueError):
                  filament_id = len(filament_id_order) + 1

                if filament_id in filaments:
                  continue

                filament_id_order.append(filament_id)
                usage[filament_id] = used_g
                filaments[filament_id] = {
                                         "id": filament_id,
                                         "tray_info_idx": filament.attrib.get("tray_info_idx"), 
                                         "type":filament.attrib.get("type"), 
                                         "color": filament.attrib.get("color"), 
                                         "used_g": used_g, 
                                         "used_m":filament.attrib.get("used_m"),
                }

            metadata["filaments"] = filaments
            metadata["usage"] = usage
            metadata["filament_id_order"] = filament_id_order
            metadata["filament_id_to_index"] = {fid: idx for idx, fid in enumerate(filament_id_order)}
        else:
          log(f"File '{slice_info_path}' not found in the archive.")
          return {}

        metadata["image"] = time.strftime('%Y%m%d%H%M%S') + ".png"

        with z.open("Metadata/plate_"+metadata["plateID"]+".png") as source_file:
          with open(os.path.join(os.getcwd(), 'static', 'prints', metadata["image"]), 'wb') as target_file:
              target_file.write(source_file.read())

        # Check for the Metadata/slice_info.config file
        gcode_path = "Metadata/plate_"+metadata["plateID"]+".gcode"
        metadata["gcode_path"] = gcode_path
        if gcode_path in z.namelist():
          with z.open(gcode_path) as gcode_file:
            metadata["filamentOrder"] =  get_filament_order(gcode_file, fallback_ids=filament_id_order)
            tool_order = sorted(metadata["filamentOrder"].items(), key=lambda entry: entry[1])
            tool_indices_by_usage = []
            for tool_id, _order in tool_order:
              try:
                tool_indices_by_usage.append(int(tool_id))
              except (TypeError, ValueError):
                continue

            tool_indices = sorted(set(tool_indices_by_usage))
            if filament_id_order:
              tool_to_filament = {}
              filament_to_tool = {}
              expected_indices = list(range(len(filament_id_order)))
              if tool_indices == expected_indices:
                for idx, filament_id in enumerate(filament_id_order):
                  tool_to_filament[idx] = filament_id
                  filament_to_tool[filament_id] = idx
              elif tool_indices_by_usage and len(tool_indices_by_usage) == len(filament_id_order):
                for idx, tool_id in enumerate(tool_indices_by_usage):
                  filament_id = filament_id_order[idx]
                  tool_to_filament[tool_id] = filament_id
                  filament_to_tool[filament_id] = tool_id

              if tool_to_filament:
                metadata["tool_index_to_filament_id"] = tool_to_filament
                metadata["filament_id_to_tool_index"] = filament_to_tool

        log(metadata)

        return metadata

  except requests.exceptions.RequestException as e:
    log(f"Error downloading file: {e}")
    return {}
  except zipfile.BadZipFile:
    log("The downloaded file is not a valid 3MF archive.")
    return {}
  except ET.ParseError:
    log("Error parsing the XML file.")
    return {}
  except Exception as e:
    log(f"An unexpected error occurred: {e}")
    return {}
  finally:
    if temp_file_name:
      try:
        os.remove(temp_file_name)
      except Exception:
        pass
