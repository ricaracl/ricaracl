#!/bin/bash

#* ==========================================================================
#* Copyright (C) Devops - LETS - All rights reserved                        *
#* Unauthorized copying of this file, via any medium is strictly prohibited *
#* Proprietary and confidential                                             *
#* Written by Ricardo Larrahona  <ricardo.larrahona@b2wdigital.com>, 2022   *
#  Script para voltar o kafka                                               *
#* ==========================================================================

ip=$(hostname -I | awk '{print $1}')
nameinstance=$(hostname)

#pegando status

sk=$(sudo supervisorctl status all | awk '{print $2}' | tail -1)

if  [ "$sk" = "RUNNING" ]
 then
  exit 0
   else
     sudo supervisorctl start kafka:kafka-0
     curl -X POST -H 'Content-Type: application/json' \
    -d '{"Status": "NOK", "message": "O Kafka parou tentei o start", "Hostname": "'$nameinstance'","PrivateIP":"'$ip'", "idWorkchat": "3297590690297477"}' \
    https://webhook.ameflash.com.br/cron
    
    sleep 30
    sk=$(sudo supervisorctl status all | awk '{print $2}' | tail -1)
    if  [ "$sk" = "RUNNING" ]
     then
       curl -X POST -H 'Content-Type: application/json' \
       -d '{"Status": "NOK", "message": "O Kafka voltou ao normal", "Hostname": "'$nameinstance'","PrivateIP":"'$ip'", "idWorkchat": "3297590690297477"}' \
       https://webhook.ameflash.com.br/cron
      else
       echo "parado"
     #sudo supervisorctl start kafka:kafka
       curl -X POST -H 'Content-Type: application/json' \
       -d '{"Status": "NOK", "message": "O Kafka mesmo apos o start nao voltou, sera preciso verificar", "Hostname": "'$nameinstance'","PrivateIP":"'$ip'", "idWorkchat": "3297590690297477"}' \
       https://webhook.ameflash.com.br/cron

fi
fi
