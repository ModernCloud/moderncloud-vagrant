#!/bin/bash

echo "----> Packages"
apk add --no-cache unzip wget bash openrc postgresql nginx docker gcc g++ nodejs npm
apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing rabbitmq-server
addgroup vagrant docker
rc-update add docker boot
rc-update add postgresql boot
rc-update add nginx boot
rc-update add rabbitmq-server boot
service docker start
service postgresql start
service nginx start
service rabbitmq-server start

echo "----> Postgresql"
echo "host all all 0.0.0.0/0 md5" >> /var/lib/postgresql/13/data/pg_hba.conf
echo "listen_addresses='*'" >> /var/lib/postgresql/13/data/postgresql.conf
service postgresql restart
psql -U postgres -c 'CREATE DATABASE moderncloud';
psql -U postgres -c "CREATE USER moderncloud WITH ENCRYPTED PASSWORD 'password'";
psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE moderncloud TO moderncloud";
psql -U postgres -c "GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO moderncloud";

echo "----> NodeJS"
npm config set package-lock false
npm install -g pm2

echo "----> Terraform"
wget -q https://releases.hashicorp.com/terraform/0.15.5/terraform_0.15.5_linux_amd64.zip
unzip terraform_0.15.5_linux_amd64.zip
rm -f terraform_0.15.5_linux_amd64.zip
mv terraform /usr/bin/terraform
chmod +x /usr/bin/terraform

echo "----> Docker"
docker pull -q moderncloud/typescript-language-server:0.1
docker pull -q moderncloud/python-language-server:0.1