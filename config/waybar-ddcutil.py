#!/usr/bin/env python

from subprocess import run
import json

data = {}
cmd = ["ddcutil", "getvcp", "10", "--bus", "1"]
p = run(cmd, check=True, text=True, capture_output=True)
if p.stdout is not None and p.stdout != "":
value=p.stdout
if p.stderr is not None and p.stderr != "":
value="0"
percentage = value.split(":")[1].split(",")[0].split("=")[1].strip(" ")
data['percentage'] = int(percentage)
print(json.dumps(data))
