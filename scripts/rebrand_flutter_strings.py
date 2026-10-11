#!/usr/bin/env python3
"""Replace StripCard only inside Dart/JSON string literals (not identifiers)."""
import re
from pathlib import Path

APP = Path(__file__).resolve().parents[1] / "main-files/stripcard-app/StripCard_User_App_v4.7.0"
BRAND = "TAKARA PAY"

DQ = re.compile(r'"([^"\\]|\\.)*"')
SQ = re.compile(r"'([^'\\]|\\.)*'")


def sub_brand(s: str) -> str:
    s = re.sub(r"Strip\s*Card", BRAND, s, flags=re.I)
    s = s.replace("StripCard", BRAND)
    return s


def fix_dart(text: str) -> str:
    def dq(m):
        inner = m.group(0)[1:-1]
        return '"' + sub_brand(inner) + '"'

    def sq(m):
        inner = m.group(0)[1:-1]
        return "'" + sub_brand(inner) + "'"

    text = DQ.sub(dq, text)
    text = SQ.sub(sq, text)
    return text


def fix_json_file(path: Path) -> None:
    text = path.read_text(encoding="utf-8")
    updated = sub_brand(text)
    if updated != text:
        path.write_text(updated, encoding="utf-8")


def main() -> None:
    for path in (APP / "lib").rglob("*.dart"):
        if not path.is_file():
            continue
        orig = path.read_text(encoding="utf-8")
        new = fix_dart(orig)
        if new != orig:
            path.write_text(new, encoding="utf-8")
    for path in (APP / "assets/lang").glob("*.json"):
        fix_json_file(path)
    # Patch bundle strings
    patch = Path(__file__).resolve().parents[1] / "main-files/stripcard-app/StripCard_User_App_Update_v4.6.0_to_v4.7.0"
    for path in patch.rglob("*.dart"):
        if not path.is_file():
            continue
        orig = path.read_text(encoding="utf-8")
        new = fix_dart(orig)
        if new != orig:
            path.write_text(new, encoding="utf-8")
    for path in patch.rglob("*.json"):
        fix_json_file(path)
    print("Flutter string rebrand done.")


if __name__ == "__main__":
    main()
