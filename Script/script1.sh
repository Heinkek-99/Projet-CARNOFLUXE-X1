#!/bin/bash
echo "*******************"
echo "Début du script N°1"
echo "*******************"
#Déclaration des variables
LOG_CSV=/home/kronft/Bureau/Csv/log.csv
LOG=/var/log/apache2/other_vhosts_access.log
HEURE_ACTU=$(date --date '1hours ago' +%H)
touch $LOG_CSV


#cut -c1-14 "$LOG" > /home/kronft/Bureau/Adresse

#rm $LOG_CSV
echo "lecture du fichier log"
#Tant qu'il y a des lignes, on récupère l'heure et les adresses IP s'étant c$
echo "Collection des différentes adresses ip et heure de connexion sur le site"
while read line
do
        # On récupère seulement les lignes où il y a écrit www.carnofluxe.do$
        GREP=$(echo $line | grep "www.carnofluxe.domain" | grep -oP "(25[0-5|2[0-4]\d|[01]?[0-9]?[0-9]\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9])|(\:([0-1][0-9]|[2][0-4])\:([0-5]?[0-9])\:([0-5]?[0-9]))" | sed 's/:/;/')
        HEURE=$(echo $GREP | grep -oP ";[0-2][0-9]" | sed "s/;//" )
        CURL=$(echo $line | grep -oP "curl")

        #Si les lignes récupérées ont la même heure que la dernière heure et$

        if [[ "$HEURE_ACTU" -le "$HEURE" ]] && [[ "$CURL" != "curl" ]]; then
                echo $GREP >> $LOG_CSV #On écrit dans le fichier log.csv
        fi


done < $LOG

echo "*********************"
echo "Fin du script N°1"
echo "*********************"
