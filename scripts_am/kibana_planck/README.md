 
O script esta rodando nas seguintes instancias

i-020fcee6d60c5f52f (ec2-sa-east-1c-p-elastickibana)   10.219.68.249

i-01051ad739d21b5aa (ec2-sa-east-1a-p-elastickibana)  10.219.70.219

i-085b41bc414b0eca0 (ec2-sa-east-1a-p-logstash)   10.219.70.165

i-0d4b610095d455427 (ec2-sa-east-1c-p-logstash) 10.219.68.211



Script para monitorar e apagar indices do elasticsearch ate ele sincronizar

para utilizar ele basta colocar no crontab desta forma:

*/10 * * * * /home/ec2-user/planck.sh
