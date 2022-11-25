#!/bin/bash

#* ==========================================================================
#* Copyright (C) Devops - LETS  All rights reserved                         *
#* Unauthorized copying of this file, via any medium is strictly prohibited *
#* Proprietary and confidential                                             *
#* Written by Ricardo Larrahona  <ricardo.larrahona@b2wdigital.com>, 2022   *
#  Script para verificar e subir containers do sac e enviar erro na sala    *
#* ==========================================================================

ip=$(hostname -I | awk '{print $1}')
nameinstance=$(hostname)
c1=$(docker ps -a | grep -v CON | grep -v twist | awk '{print $1}' | head -1)
c2=$(docker ps -a | grep -v CON | grep -v twist | awk '{print $1}' | tail -1)


nc=$(docker ps | grep -v CON | grep -v twist | awk '{print $1}' | wc -l)
if  [ "$nc" -eq "2" ]
  then
   echo "ok"
   exit 0
   elif [ "$nc" -eq "0" ]
    then
    #echo "sobe os dois container"
    date=`date +%d/%m/%Y" - "%H:%M:%S`
    docker ps -a | grep -v CON | grep -v twist | awk '{print $1}' | xargs -I % docker start %
    echo "O container $c1 e o $c2 pararam as $date" >> /home/ec2-user/log_problema.txt
    curl -X POST -H 'Content-Type: application/json' \
    -d '{"Status": "NOK", "message": "O container '$c1' e o '$c2' pararam e ja voltaram", "Hostname": "'$nameinstance'","PrivateIP":"'$ip'", "idWorkchat": "3297590690297477"}' \
    https://webhook.ameflash.com.br/cron
else
     cr=$(docker ps | grep -v CON | grep -v twist | awk '{print $1}'| head -1)

  if  [ "$cr" == "$c1" ]
     then
      #echo "inicio o c2"
      date=`date +%d/%m/%Y" - "%H:%M:%S`
      docker start $c2
      echo "O conteiner $c2 parou as $date" >> /home/ec2-user/log_problema.txt
      curl -X POST -H 'Content-Type: application/json' \
      -d '{"Status": "NOK", "message": "O container '$c2' parou mas ja voltou ao normal", "Hostname": "'$nameinstance'","PrivateIP":"'$ip'", "idWorkchat": "3297590690297477"}' \
      https://webhook.ameflash.com.br/cron  
     else
     #echo "inicio o c1"
      date=`date +%d/%m/%Y" - "%H:%M:%S`
      docker start $c1
      echo "O conteiner $c1 parou as $date" >> /home/ec2-user/log_problema.txt
     
      curl -X POST -H 'Content-Type: application/json' \
      -d '{"Status": "NOK", "message": "O container '$c1' parou mas ja voltou ao normal", "Hostname": "'$nameinstance'","PrivateIP":"'$ip'", "idWorkchat": "3297590690297477"}' \
      https://webhook.ameflash.com.br/cron 
      
fi
fi
