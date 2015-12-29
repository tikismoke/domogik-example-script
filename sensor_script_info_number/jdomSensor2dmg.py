#!/usr/bin/python
# -*- coding: utf-8 -*-									   

'''
Script pour importer les senseurs Jeedom dans Domogik.
Option '-h' pour l'aide.

'''


import sys
import argparse
import urllib2
from urllib2 import Request, urlopen, URLError, HTTPError

# Info. APIKEY JEEDOM
jeedomapikey = "0123456789abcdefghij"


def main():

        global jeedomapikey
        parser = argparse.ArgumentParser()
        parser.add_argument('-s', '--server', help='Jeedom server', required=True )
        parser.add_argument('-i', '--id', help='Sensor ID', required=True)
        parser.add_argument('-t', '--type',  help='diy|box hardware (default diy)', default="diy")
        parser.add_argument('-k', '--key',  help='Optionnaly Jeedom API Key, can be set in program')

        opts = parser.parse_args()

        #print(opts)
        jeedomhost = opts.server
        jeedomcmdid = opts.id
        jeedomtype = "/jeedom" if opts.type == "diy" else ""
        if opts.key:
                jeedomapikey = opts.key

        # -------------------------------------------------------------
        # Lit donnée sur Jeedom
        # -------------------------------------------------------------
        JEEDOMURL = "http://" + jeedomhost + jeedomtype + "/core/api/jeeApi.php?api=" + jeedomapikey + "&type=cmd&id=" + jeedomcmdid
        #print(JEEDOMURL) ;

        try:
                urlget = urllib2.urlopen(JEEDOMURL)
        except HTTPError, err:
                print("HTTPError %d" % err.code)
                sys.exit(1)
        except URLError, err:
                print("URLError %s" % err.reason)
                sys.exit(1)
        else:
		value = urlget.read()
		urlget.close()
		print value
		if ("API non valide" in value) or ("Aucune commande correspondant" in value):
			sys.exit(1)


if __name__ == "__main__":
	main()

