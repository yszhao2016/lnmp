#!/bin/bash
user="www"
group="www"
nginxpackage="nginx-1.18.0.tar.gz"
nginx_installpackage_dir=${nginxpackage%%.tar*}
nginx_download_url="http://nginx.org/download/nginx-1.18.0.tar.gz"

source ./function.sh


yumBaseModule
isPackageAndWgetAndTar   ${nginxpackage}  ${nginx_download_url}
createUser www www





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




