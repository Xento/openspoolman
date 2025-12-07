import json
import re
try:
    from dotenv import load_dotenv
    load_dotenv()
except ModuleNotFoundError:
    pass
from mqtt_bambulab import processMessage


def replay_messages(log_file: str) -> None:
    """Replay MQTT messages from a log file."""
    i = 1
    with open(log_file, "r", encoding="utf-8") as file:
        for line in file:
            cleaned_line = re.sub(r"^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} :: ", "", line.strip())
            print("row " + str(i))
            i += 1
            processMessage(json.loads(cleaned_line))


def run_test():
    replay_messages("mqtt.log")


if __name__ == "__main__":
    run_test()
