from dotenv import load_dotenv
from mqtt_bambulab import iter_mqtt_payloads_from_log, processMessage 
from logger import log

load_dotenv()

def run_test():
  for idx, payload in enumerate(iter_mqtt_payloads_from_log("mqtt.log"), start=1):
    log("row " + str(idx))
    processMessage(payload)


run_test()
