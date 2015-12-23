#!/usr/bin/python
from urllib import urlopen
import json
url = urlopen('http://ip_of_domogik:-port-of-rest/stats/device_id/device_state/latest').read()
if json.loads(url)['stats'][0]['value']=="off":
    print "0"
else:
    print "1"
