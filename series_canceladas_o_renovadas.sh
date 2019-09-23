#!/bin/bash

#Notificaciones telegram
TELEGRAMAPIKEY="bot000000000:00000000000000000000000000000000000"
TELEGRAMCHANNEL="-000000000"

#Si no existen los archivos del histórico, lo creamos (suponemos que es la primera ejecución)
if ! [[ -e /var/tmp/series.canceladas ]]; then

    curl -s -L https://lovingseries.com/renovada-cancelada/ | grep 'color:#ff0000;' | sed 's/<p>//'g | sed 's/<strong>//g' | cut -d '>' -f2 | cut -d '<' -f1 | sed "s/ : CANCELADA//g" | egrep -v " ROJO$" | sed "s/&#8217;/'/g" | sed "s/\&amp;/\&/g" | sed "s/\&#8211;/-/g" | sed 's/^ //' > /var/tmp/series.canceladas

fi

if ! [[ -e /var/tmp/series.renovadas ]]; then

    curl -s -L https://lovingseries.com/renovada-cancelada/ | grep 'color:#008000;' | sed 's/<p>//'g | sed 's/<strong>//g' | cut -d '>' -f2 | cut -d '<' -f1 | sed "s/ : RENOVADA//g" | egrep -v " VERDE$" | sed "s/&#8217;/'/g" | sed "s/\&amp;/\&/g"  | sed "s/\&#8211;/-/g" | sed 's/^ //' > /var/tmp/series.renovadas

fi




#Recorremos la web y avisamos si una nueva línea no está en el archivo de histórico (por lo tanto es una nueva entrada)
curl -s -L https://lovingseries.com/renovada-cancelada/ | grep 'color:#ff0000;' | sed 's/<p>//'g | sed 's/<strong>//g' | cut -d '>' -f2 | cut -d '<' -f1 | sed "s/ : CANCELADA//g" | egrep -v " ROJO$" | sed "s/&#8217;/'/g" | sed "s/\&amp;/\&/g" | sed "s/\&#8211;/-/g" | sed 's/^ //' | while read CANCELADA
do


    #Comprobamos si está en el archivo /var/tmp/series.canceladas
    if ! grep -Fxq "$CANCELADA" /var/tmp/series.canceladas; then

        curl -s -X POST https://api.telegram.org/${TELEGRAMAPIKEY}/sendMessage -F chat_id=$TELEGRAMCHANNEL -F text="💀 Serie cancelada: *${CANCELADA}*" -F parse_mode=markdown
        echo "$CANCELADA" >> /var/tmp/series.canceladas 

    fi


done



#Renovadas
curl -s -L https://lovingseries.com/renovada-cancelada/ | grep 'color:#008000;' | sed 's/<p>//'g | sed 's/<strong>//g' | cut -d '>' -f2 | cut -d '<' -f1 | sed "s/ : RENOVADA//g" | egrep -v " VERDE$" | sed "s/&#8217;/'/g" | sed "s/\&amp;/\&/g"  | sed "s/\&#8211;/-/g" | sed 's/^ //' | while read RENOVADA
do

    #Comprobamos si está en el archivo /var/tmp/series.renovadas
    if ! grep -Fxq "$RENOVADA" /var/tmp/series.renovadas; then

        curl -s -X POST https://api.telegram.org/${TELEGRAMAPIKEY}/sendMessage -F chat_id=$TELEGRAMCHANNEL -F text="📝 Serie renovada: *${RENOVADA}*" -F parse_mode=markdown
        echo "$RENOVADA" >> /var/tmp/series.renovadas 

    fi



done
