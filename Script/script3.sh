#!/bin/bash
#LOG = /home/kronft/Bureau/log.csv
#STATUS = /home/kronft/SaveDns/status.sh
echo "**********************"
echo "Début du script N°3 "
echo "**********************"
echo "Transposition csv vers html"
echo "....."
echo "Conversion fichier log.csv"
csv2html  --table border="2" /home/kronft/Bureau/log.csv  -d\; --tr Adresse-IP --th Adresse-IP --th Heure --th Heure -c >  /home/kronft/Bureau/Html/log.html
echo "Réussite avec le fichier log.csv"
echo "....."
echo "Conversion fichier status.csv"
csv2html --table border="2" /home/kronft/SaveDns/status.csv -d\; -c > /home/kronft/Bureau/Html/status.html
echo "Réussite avec le fichier status.csv"
cat  /var/www/carnofluxe/index.html > /home/kronft/Bureau/Html/reg.csv
echo "Suppression de la page"
cat  /home/kronft/Bureau/reg.csv  >  /var/www/carnofluxe/index.html
echo "**********************"
echo "Fin du script N°3"
echo "**********************"
