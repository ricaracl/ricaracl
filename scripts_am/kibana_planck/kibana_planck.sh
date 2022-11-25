#!/bin/bash

#* ==========================================================================
#* Copyright (C) Devops - LETS - All rights reserved                        *
#* Unauthorized copying of this file, via any medium is strictly prohibited *
#* Proprietary and confidential                                             *
#* Written by Ricardo Larrahona  <ricardo.larrahona@b2wdigital.com>, 2022   *
#  Script para verificar e voltar o elasticsearch do planck                 *
#* ==========================================================================

ip=$(hostname -I | awk '{print $1}')
nameinstance=$(hostname)
ste=$(curl localhost:9200/_cat/health -s | awk '{print $4}')
dt=$(date | awk '{print $3}')

if  [ "$ste" = "green" ]
 then
  exit 0
 else
  nig=$(curl -XGET http://localhost:9200/_cat/indices?v | grep gb | awk '{print $3"    "$9}' | sort -k2 -n | tail -1 | awk '{print $1}')
  dig=$(curl -XGET http://localhost:9200/_cat/indices?v | grep gb | awk '{print $3"    "$9}' | sort -k2 -n | tail -1 | awk '{print $1}' | cut -d"." -f3 | cut -d"-" -f1)
  curl -X POST -H 'Content-Type: application/json' \
  -d '{"Status": "NOK", "message": "O kibana do planck parou", "Hostname": "'$nameinstance'","PrivateIP":"'$ip'", "idWorkchat": "3297590690297477"}' \
  https://webhook.ameflash.com.br/cron

if [ "$dt" -ne "$dig" ]
  then
    curl -XDELETE localhost:9200/$nig
    systemctl restart elasticsearch.service
    sleep 60
    if  [ "$ste" = "green" ]
     then
      curl -X POST -H 'Content-Type: application/json' \
      -d '{"Status": "NOK", "message": "O kibana do planck voltou ao normal", "Hostname": "'$nameinstance'","PrivateIP":"'$ip'", "idWorkchat": "3297590690297477"}' \
      https://webhook.ameflash.com.br/cron
    
    else
    nig=$(curl -XGET http://localhost:9200/_cat/indices?v | grep gb | awk '{print $3"    "$9}' | sort -k2 -n | tail -2 | awk '{print $1}' | head -1) 
    dig=$(curl -XGET http://localhost:9200/_cat/indices?v | grep gb | awk '{print $3"    "$9}' | sort -k2 -n | tail -2 | awk '{print $1}' | cut -d"." -f3 | cut -d"-" -f1 | head -1)
      
    if [ "$dt" -ne "$dig" ]
     then
     curl -XDELETE localhost:9200/$nig
     systemctl restart elasticsearch.service
     sleep 60
    if  [ "$ste" = "green" ]
     then
      curl -X POST -H 'Content-Type: application/json' \
      -d '{"Status": "NOK", "message": "O kibana do planck voltou ao normal", "Hostname": "'$nameinstance'","PrivateIP":"'$ip'", "idWorkchat": "3297590690297477"}' \
      https://webhook.ameflash.com.br/cron
    else 
    nig=$(curl -XGET http://localhost:9200/_cat/indices?v | grep gb | awk '{print $3"    "$9}' | sort -k2 -n | tail -3 | awk '{print $1}' | head -1) 
    dig=$(curl -XGET http://localhost:9200/_cat/indices?v | grep gb | awk '{print $3"    "$9}' | sort -k2 -n | tail -3 | awk '{print $1}' | cut -d"." -f3 | cut -d"-" -f1 | head -1)
    curl -XDELETE localhost:9200/$nig
    systemctl restart elasticsearch.service
    sleep 60
    if  [ "$ste" = "green" ]
     then
      curl -X POST -H 'Content-Type: application/json' \
      -d '{"Status": "NOK", "message": "O kibana do planck voltou ao normal", "Hostname": "'$nameinstance'","PrivateIP":"'$ip'", "idWorkchat": "3297590690297477"}' \
      https://webhook.ameflash.com.br/cron
    fi
    fi
    fi
    fi
fi
fi
