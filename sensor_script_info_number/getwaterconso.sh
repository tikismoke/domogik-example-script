#!/bin/bash

# Affiche la consommation d'eau par "jour|mois|annee" d'un sensor Domogik de type compteur incremental
# Le sensor stocke en base la consomation en litre d'eau à chaque minute.
# Calcul fait par une formula ajoutée dans les propriété du sensor.
# Avec un compteur incrémenté à chaque 1/4 de litre, la formule : round(VALUE * 0.25, 2)
# Le paramètre jour retourne une valeur en litres, mois/annéee en m3.

# Ajouter un .my.cnf dans le "HOME" du "user" utlisant le script pour accéder à la base sans password.
# cat .my.cnf
#       [client]
#       host = localhost
#       port = 3316
#       user = domogik
#       password = domopass
#       [mysql]
#       prompt=(\\u@\\h) [\\d]>\\_

# ./getwaterconso.sh -d 200 -p jour
# 334.2

# ------------------------------------------------------------------------------
function usage()
{
        echo "-------------------------------------------------------------------------------------"
        echo "Usage: $0  -d "domogik-inc-counter_id"  -p 'jour|mois|annee'"
        echo "Exemple: $0 -d 200 -p jour"
        echo "-------------------------------------------------------------------------------------"
        exit 1
}

if [ $# -lt 4 ]
then
        usage
fi

while getopts d:p: option
do
        case $option in
        d)
                DEVICE=$OPTARG
        ;;
        p)
                PERIODE=$OPTARG
        ;;
        :) usage
        ;;
        ?) usage
        ;;
        *) echo "Paramètre inconnu."
           usage
        ;;
        esac
done

if [ $PERIODE = jour ]
then
        DATE=$(date '+%Y-%m-%d')
        CUMUL=$(echo "SELECT DATE_FORMAT(date,'%Y-%m-%d'), ROUND(SUM(value_num), 1) as conso FROM core_sensor_history WHERE sensor_id=$DEVICE and date>\"$DATE 00:00:00\" and date<=\"$DATE 23:59:59\"" | mysql -s domogik)
elif [ $PERIODE = mois ]
then
        MOIS=$(date '+%Y-%m')
        CUMUL=$(echo "SET lc_time_names = 'fr_FR'; SELECT DATE_FORMAT(date,'%M') as Mois , ROUND(SUM(value_num)/1000, 2) as 'conso' FROM core_sensor_history WHERE sensor_id=$DEVICE and date>\"$MOIS\"  GROUP by Mois" | mysql -s domogik)
elif [ $PERIODE = annee ]
then
        ANNEE=$(date '+%Y')
        CUMUL=$(echo "SELECT DATE_FORMAT(date,'%Y') as year , ROUND(SUM(value_num)/1000, 1) as 'conso' FROM core_sensor_history  WHERE sensor_id=$DEVICE and date>\"$ANNEE\"" | mysql -s domogik)
else
        echo "Periode inconnu (-p)."
        usage
fi

#echo "Consommation : $CUMUL"
VALUE=$(echo $CUMUL | cut -d ' ' -f2)
if [ "$VALUE" = "NULL" -o -z "$VALUE" ]
then
        echo "FAILED"
        exit 1
else
        echo $VALUE
fi

