#!/usr/bin/python
import sys
import telnetlib

HOST = "zoneminder"
PORT = "6802"

tn = telnetlib.Telnet(HOST,PORT)

tn.write("4|on+15|1|Alarme|Domogik External Motion|\n")
'''
monitor_id|action|score|cause|text|showtext
See https://wiki.zoneminder.com/How_to_use_your_external_camera's_motion_detection_with_ZM
'''
tn.close()
