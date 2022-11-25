 #!/bin/bash

#* ==========================================================================
#* Copyright (C) Devops -LETS - All rights reserved                         *
#* Unauthorized copying of this file, via any medium is strictly prohibited *
#* Proprietary and confidential                                             *
#* Written by Ricardo Larrahona  <ricardo.larrahona@b2wdigital.com>, 2022   *
#  Script para verificar o metabase e reiniciar e enviar erro na sala       *
#* ==========================================================================

ip=$(hostname -I | awk '{print $1}')
nameinstance=$(hostname)

status_m=$(curl -s http://10.221.211.46:3001/api/health | cut -d':' -f2 | cut -d'"' -f2)

if  [ "$status_m" == "ok" ]
  then
   #echo "ok"
   exit 0
   else
   docker restart voe-metabase-app
   curl -X POST -H 'Content-Type: application/json' \
   -d '{"Status": "NOK", "message": "O metabase parou mas ja voltou ", "Hostname": "'$nameinstance'","PrivateIP":"'$ip'", "idWorkchat": "3297590690297477"}' \
   https://webhook.ameflash.com.br/cron
fi
