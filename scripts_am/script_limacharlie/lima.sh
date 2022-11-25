#!/bin/bash

#* ===================================================================================
#* Copyright (C) Devops - LETS - All rights reserved                                 * 
#* Unauthorized copying of this file, via any medium is strictly prohibited          *
#* Proprietary and confidential                                                      *
#* Written by Ricardo Larrahona  <ricardo.larrahona@b2wdigital.com>, 2022            *
#  Script  para matar processos a mais e iniciar as que nao iniciaram o lima charlie *
#* ===================================================================================

pl=$(ps auxf | grep rphcp | grep -v grep | awk '{print $2}' | wc -l)

if  [ "$pl" -eq "1" ]
  then
   exit 0;

elif [ "$pl" -eq "0" ]
  then
    /etc/rc.d/init.d/limacharlie start

elif [ "$pl" -gt "1" ]
  then
    pl=$(ps auxf | grep rphcp | grep -v grep | awk '{print $2}' | wc -l)
     while [ $pl -ne "1" ]; do
       ps auxf | grep rphcp | grep -v grep | awk '{print $2}' | tail -1 | xargs -I % kill -9 %
       pl=$(ps auxf | grep rphcp | grep -v grep | awk '{print $2}' | wc -l)
     done  

