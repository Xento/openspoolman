import requests
import zipfile
import tempfile
import xml.etree.ElementTree as ET
import ftplib
from ftplib import all_errors
import ssl
import os
import re
from datetime import datetime
from config import PRINTER_ID, PRINTER_CODE, PRINTER_IP

class ImplicitFTP_TLS(ftplib.FTP_TLS):
	def __init__(self, *args, **kwargs):
		super().__init__(*args, **kwargs)
		self._sock = None
	@property
	def sock(self):
		"""Return the socket."""
		return self._sock
	@sock.setter
	def sock(self, value):
		"""When modifying the socket, ensure that it is ssl wrapped."""
		if value is not None and not isinstance(value, ssl.SSLSocket):
			value = self.context.wrap_socket(value)
		self._sock = value

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

def parse_date(item):
    """Parse the date and time from the FTP listing item."""
    try:
        date_str = f"{item['month']} {item['day']} {item['time_or_year']}"
        return datetime.strptime(date_str, "%b %d %H:%M")
    except ValueError:
        return None

def get_filament_order(file):
    filament_usage = {} 
    switch_count = 0 

    for line in file:
        match_filament = re.match(r"^M620 S(\d+)[^;\r\n]*$", line.decode("utf-8").strip())
        if match_filament:
            filament = int(match_filament.group(1))
            if filament not in filament_usage:
                filament_usage[filament] = switch_count
            switch_count += 1

    return filament_usage

def download3mfFromCloud(url, destFile):
  print("Downloading 3MF file from cloud...")
  # Download the file and save it to the temporary file
  response = requests.get(url)
  response.raise_for_status()
  destFile.write(response.content)

def download3mfFromFTP(filename, destFile):
  print("Downloading 3MF file from ftp...")
  ftp = ImplicitFTP_TLS()
  ftp.set_pasv(True)
  ftp.connect(host=PRINTER_IP, port=990, timeout=5, source_address=None)
  ftp.login('bblp', PRINTER_CODE)
  ftp.prot_p()#

  # TODO: Check if file exists in cache else it is from the model folder
  ftp.retrbinary(f'RETR /cache/'+filename, destFile.write)
      
  ftp.quit()

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
  try:
    # Create a temporary file
    with tempfile.NamedTemporaryFile(delete_on_close=False,delete=True, suffix=".3mf") as temp_file:
      temp_file_name = temp_file.name
      
      if url.startswith("http"):
        download3mfFromCloud(url, temp_file)
      elif url.startswith("local:"):
        download3mfFromLocalFilesystem(url.replace("local:", ""), temp_file)
      else:
        download3mfFromFTP(url, temp_file)
      
      temp_file.close()

      print(f"3MF file downloaded and saved as {temp_file_name}.")

      # Unzip the 3MF file
      with zipfile.ZipFile(temp_file_name, 'r') as z:

        metadata = {}

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
            for plate in root.findall(".//plate"):
              for filament in plate.findall(".//filament"):
                used_g = filament.attrib.get("used_g")
                filamentId = int(filament.attrib.get("id"))
                
                usage[filamentId] = used_g

            metadata["usage"] = usage
        else:
          print(f"File '{slice_info_path}' not found in the archive.")
          return {}
        
        # Check for the Metadata/slice_info.config file
        gcode_path = "Metadata/plate_"+metadata["plateID"]+".gcode"
        if gcode_path in z.namelist():
          with z.open(gcode_path) as gcode_file:
            metadata["filamentOrder"] = get_filament_order(gcode_file)

        return metadata

  except requests.exceptions.RequestException as e:
    print(f"Error downloading file: {e}")
    return {}
  except zipfile.BadZipFile:
    print("The downloaded file is not a valid 3MF archive.")
    return {}
  except ET.ParseError:
    print("Error parsing the XML file.")
    return {}
  except Exception as e:
    print(f"An unexpected error occurred: {e}")
    return {}
