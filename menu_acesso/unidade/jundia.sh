#!/usr/bin/expect
set password "password"
spawn ssh root@200.200.200.200 -p 2220
expect "Password for root@jundiai:"
send "$password\r"
expect "Enter an option:"
send "8\r"
interact 
