#!/bin/bash
user="www"
group="www"
nginxpackage="nginx-1.18.0.tar.gz"
nginx_installpackage_dir=${nginxpackage%%.tar*}

source ./function.sh

#create group if not exists
egrep "^$group" /etc/group >& /dev/null
if [ $? -ne 0 ]
then
    groupadd $group
fi

#create user if not exists
egrep "^$user" /etc/passwd >& /dev/null
if [ $? -ne 0 ]
then
    useradd ${user} -g ${group} -s /sbin/nologin -M
fi



./configure --prefix=/usr/local/nginx \
--with-http_stub_status_module \
--with-http_gzip_static_module \
--with-http_ssl_module \
--with-http_realip_module \
--user=${user} \
--group=${group} \


make && make install


servicefile="/usr/lib/systemd/system/nginx.service"
if [ ! -f ${servicefile}  -a  ! -h ${servicefile} ]
then
	cp -f ../config/nginx.service  /usr/lib/systemd/system/
fi
 
systemctl enable nginx.service

systemctl disable nginx.service

systemctl restart nginx.service




