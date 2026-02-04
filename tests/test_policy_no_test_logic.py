from pathlib import Path


def test_no_direct_mqtt_log_parsing_in_tests():
    test_root = Path(__file__).resolve().parent
    offenders = []

    for path in test_root.rglob("*.py"):
        if path.name == Path(__file__).name:
            continue
        text = path.read_text(encoding="utf-8")
        if "split(\"::\"" in text or "split('::'" in text:
            offenders.append(str(path))

    assert not offenders, (
        "Direct mqtt.log parsing detected in tests. "
        f"Move log parsing into production helpers instead: {', '.join(offenders)}"
    )
