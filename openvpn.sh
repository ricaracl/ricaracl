#!/usr/bin/expect
##########################################################
## vpn.sh - Conecta automaticamente um openvpn-client    #
## Escrito por: Ricardo Larrahona                        #
## Data: 27/12/2016                                      #
## E-mail: ricardo.larrahona@bluepex.com                 #
##########################################################
#entra no diretorio onde esta o arquivo .ovpn
cd /home/ricaracl/Downloads/utm-udp-1198/ 
set username "usuario"
set password "senha"
spawn openvpn utm-udp-1198.ovpn 
expect "Enter Auth Username:"
send "$username\r"
expect "Enter Auth Password:"
send "$password\r"
interact
