#!/bin/bash

#* ==========================================================================
#* Copyright (C) Devops - LETS - All rights reserved                        *
#* Unauthorized copying of this file, via any medium is strictly prohibited *
#* Proprietary and confidential                                             *
#* Written by Ricardo Larrahona  <ricardo.larrahona@b2wdigital.com>, 2022   *
#  Script para verificar e voltar o elasticsearch do planck                 *
#* ==========================================================================

ip=$(hostname -I | awk '{print $1}')
ste=$(curl localhost:9200/_cat/health -s | awk '{print $4}')
dt=$(date | awk '{print $3}')

#functions
function msg_ok_status_yellow() {
  curl -X POST -H 'Content-Type: application/json' \
  -d '{"Status": "NOK", "message": "O Elastisearch do planck voltou ao normal estava com o status yellow, agora esta green", "indice deletado": "'$nig'","PrivateIP":"'$ip'", "idWorkchat": "3297590690297477"}' \
  https://webhook.ameflash.com.br/cron
}
function msg_restart() {
  curl -X POST -H 'Content-Type: application/json' \
  -d '{"Status": "NOK", "message": "O Elastisearch do planck esta com o status vazio o serviço sera restartado", "Hostname": "'$nameinstance'","PrivateIP":"'$ip'", "idWorkchat": "3297590690297477"}' \
  https://webhook.ameflash.com.br/cron
}
function msg_restart_ok() {
  curl -X POST -H 'Content-Type: application/json' \
  -d '{"Status": "NOK", "message": "O Elastisearch do planck esta ok apos o restart", "Hostname": "'$nameinstance'","PrivateIP":"'$ip'", "idWorkchat": "3297590690297477"}' \
  https://webhook.ameflash.com.br/cron
}
function deleta() {
  curl -XDELETE localhost:9200/$nig
  systemctl restart elasticsearch.service
  ssh root@10.219.70.219 -t "systemctl restart elasticsearch.service"
  sleep 120
  ste=$(curl localhost:9200/_cat/health -s | awk '{print $4}')
  if  [ "$ste" = "green" ]
     then
      msg_ok_status_yellow
  fi    
}

if  [ "$ste" = "green" ]
 then
  exit 0
 elif [ "$ste" = " " ] 
    then
     msg_restart
     systemctl restart elasticsearch.service
     ssh root@10.219.70.219 -t "systemctl restart elasticsearch.service"
     sleep 120
     ste=$(curl localhost:9200/_cat/health -s | awk '{print $4}')
    if  [ "$ste" = "green" ]
     then
      msg_restart_ok 
elif ["$ste" = "yellow"]
 then
  curl -X POST -H 'Content-Type: application/json' \
  -d '{"Status": "NOK", "message": "O Elasticsearch do planck esta com status yellow e ja esta sendo corrigido", "Hostname": "'$nameinstance'","PrivateIP":"'$ip'", "idWorkchat": "3297590690297477"}' \
  https://webhook.ameflash.com.br/cron
  
  nig=$(curl -s -XGET http://localhost:9200/_cat/indices?v | grep gb | awk '{print $3"    "$9}' | sort -k2 -n | tail -1 | awk '{print $1}')
  dig=$(curl -s -XGET http://localhost:9200/_cat/indices?v | grep gb | awk '{print $3"    "$9}' | sort -k2 -n | tail -1 | awk '{print $1}' | cut -d"." -f3 | cut -d"-" -f1)

if [ "$dt" -ne "$dig" ]
  then
    nig=$(curl -s -XGET http://localhost:9200/_cat/indices?v | grep gb | awk '{print $3"    "$9}' | sort -k2 -n | tail -1 | awk '{print $1}')     
    deleta
  else
    nig=$(curl -s -XGET http://localhost:9200/_cat/indices?v | grep gb | awk '{print $3"    "$9}' | sort -k2 -n | tail -2 | awk '{print $1}' | head -1) 
    dig=$(curl -s -XGET http://localhost:9200/_cat/indices?v | grep gb | awk '{print $3"    "$9}' | sort -k2 -n | tail -2 | awk '{print $1}' | cut -d"." -f3 | cut -d"-" -f1 | head -1)
      
   if [ "$dt" -ne "$dig" ]
     then
     nig=$(curl -s -XGET http://localhost:9200/_cat/indices?v | grep gb | awk '{print $3"    "$9}' | sort -k2 -n | tail -2 | awk '{print $1}' | head -1)             
     deleta
    else 
    nig=$(curl -s -XGET http://localhost:9200/_cat/indices?v | grep gb | awk '{print $3"    "$9}' | sort -k2 -n | tail -3 | awk '{print $1}' | head -1) 
    deleta
   fi    
   fi      
  fi
 fi