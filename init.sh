#!/bin/bash

echo "----> Packages"
apk add --no-cache unzip wget bash openrc mysql mysql-client nginx docker gcc g++ nodejs npm
apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing rabbitmq-server
/etc/init.d/mariadb setup
addgroup vagrant docker
rc-update add docker boot
rc-update add mariadb boot
rc-update add nginx boot
rc-update add rabbitmq-server boot
service docker start
service mariadb start
service nginx start
service rabbitmq-server start

echo "----> NodeJS"
npm config set package-lock false
npm install -g pm2

echo "----> Terraform"
wget -q https://releases.hashicorp.com/terraform/0.14.8/terraform_0.14.8_linux_amd64.zip
unzip terraform_0.14.8_linux_amd64.zip
rm -f terraform_0.14.8_linux_amd64.zip
mv terraform /usr/bin/terraform
chmod +x /usr/bin/terraform

echo "----> Docker"
docker pull -q moderncloud/typescript-language-server:0.1
docker pull -q moderncloud/python-language-server:0.1