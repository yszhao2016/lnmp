#!/bin/bash

localyumpackage="mysql80-community-release-el7-3.noarch.rpm"

if [ ! -f ${localyumpackage} ];
then
  wget https://repo.mysql.com//mysql80-community-release-el7-3.noarch.rpm
fi

yum localinstall -y ${localyumpackage}


yum install -y mysql-community-server

systemctl restart  mysqld.service

echo -e "\n初始密码\n";
grep 'temporary password' /var/log/mysqld.log
sleep(3)

systemctl enable mysqld

systemctl daemon-reload



