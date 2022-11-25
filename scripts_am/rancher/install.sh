#!/bin/bash

#* ==========================================================================
#* Copyright (C) Devops -LETS - All rights reserved                         *
#* Unauthorized copying of this file, via any medium is strictly prohibited *
#* Proprietary and confidential                                             *
#* Written by Ricardo Larrahona  <ricardo.larrahona@b2wdigital.com>, 2022   *
#  Script instalar rancher a parte de um jumpserver                         *
#* ==========================================================================

#Instalar Kubectl
echo 'instalando o kubectl'
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl

#Instalar RKE
echo 'instalando o rke'
curl -LO https://github.com/rancher/rke/releases/download/v1.3.1/rke_linux-amd64
mv rke_linux-amd64 rke
chmod +x rke
mv ./rke /usr/local/bin/rke

#baixar um rancher-cluster.yml pronto
#arumar acesso da chave pem no user
echo 'instalanddo o rke nos nodes'
rke up --config /home/ricardo.larrahona/rancher-cluster.yml

#kubeconfig
export KUBECONFIG=$(pwd)/kube_config_rancher-cluster.yml

#install HELM
echo 'instalando o helm'
 curl -LO https://get.helm.sh/helm-v3.8.1-linux-amd64.tar.gz
 tar -zxvf helm-v3.8.1-linux-amd64.tar.gz
 sudo mv linux-amd64/helm /usr/local/bin/helm 

#preparar para rancher
echo 'preparando o name space para o rancher'
helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
helm repo update
kubectl create namespace cattle-system


#certificado
echo 'criando o name space para o cert'
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.7.1/cert-manager.yaml
kubectl create namespace cert-manager
helm repo add jetstack https://charts.jetstack.io
helm repo update

#install certmanager
echo 'intalanddo o certmanager'
helm install \
cert-manager jetstack/cert-manager \
--namespace cert-manager \
--version v1.7.1 

#install rancher
echo 'instalando rancher'
helm upgrade --install rancher rancher-stable/rancher \
--namespace cattle-system \ --set hostname=rancher-rke2.lets-devops.com.br \
--set tls=external \
--set replicas=3

#iniciar o nginx no jumperserver
echo 'iniciando o nginx ingress'
docker run -d --restart=unless-stopped -p 80:80 -v /home/ec2-user/nginx.conf:/etc/nginx/nginx.conf nginx:1.21.3
