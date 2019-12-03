#!/bin/bash
###################################################################
## acesso.sh - Conecta automaticamente a uma unidade via ssh      #
## Somente o menu de acesso que chama outro script que usa expect #
## Escrito por: Ricardo Larrahona                                 #
## Data: 23/05/2019                                               #
## E-mail: ricardo.larrahona@bluepex.com                          #
###################################################################
#banner
figlet UNIDADES_ACESSOS
echo
echo
echo
echo
echo -e "\033[1;31m Digite o nome da  unidade ou numero que deseja acessar:  \033[0m"
echo
echo
echo "1 - jundiai"
echo
echo "2 - campinas_f"
echo
echo "3 - campinas_b"
echo
echo "4 - sorocaba"
echo
echo "5 - limeira"
echo
echo "6 - ribeirao"

echo


read unidade

if [ "$unidade" = "jundiai" -o  "$unidade" = "1" ];then
echo "acessando unidade de jundiai"
/home/ricaracl/scriptricadeb/acesso/jundiai/./jundiai.sh
fi

if [ "$unidade" = "campinas_f" -o  "$unidade" = "2" ];then
echo "acessando unidade de campinas frontend"
/home/ricaracl/scriptricadeb/acesso/campinas_f/./campinas_f.sh
fi

if [ "$unidade" = "campinas_b" -o  "$unidade" = "3" ];then
echo "acessando unidade de campinas backend"
/home/ricaracl/scriptricadeb/acesso/campinas_b/./campinas_b.sh
fi

if [ "$unidade" = "sorocaba" -o  "$unidade" = "4" ];then
echo "acessando unidade de sorocaba"
/home/ricaracl/scriptricadeb/acesso/sorocaba/./sorocaba.sh
fi

if [ "$unidade" = "limeira" -o  "$unidade" = "5" ];then
echo "acessando unidade de limeira"
/home/ricaracl/scriptricadeb/acesso/limeira/./limeira.sh
fi

if [ "$unidade" = "ribeirao" -o  "$unidade" = "6" ];then
echo "acessando unidade de ribeirao"
/home/ricaracl/scriptricadeb/acesso/ribeirao/./ribeirao.sh
fi


sleep 2

