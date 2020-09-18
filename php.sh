#!/bin/bash


homepath=$(pwd)

phppackage="php-7.3.22.tar.gz"
phppackage_download_url="https://www.php.net/distributions/php-7.3.22.tar.gz"
php_install_package_dir=${phppackage%%.tar*}



libzip_package="libzip-1.5.2.tar.gz"
libzip_package_download_url="https://libzip.org/download/libzip-1.5.2.tar.gz"
libzip_package_dir=${libzip_package%%.tar*}


. ./function.sh

yumBaseModule
yum remove -y libzip
isPackageAndWgetAndTar   ${libzip_package} ${libzip_package_download_url}
cd ${libzip_package_dir}
mkdir bulid
cd bulid
cmake ..
make && make install
cd $homepath



isPackageAndWgetAndTar   ${phppackage}   ${phppackage_download_url}



#--------解决执行configure报错error: off_t undefined; check your library configuration
echo '/usr/local/lib64
/usr/local/lib
/usr/lib
/usr/lib64'>>/etc/ld.so.conf


ldconfig -v

./configure --prefix=/usr/local/php \
--enable-fileinfo \
--enable-fpm  \
--with-config-file-path=/etc/php \
--with-config-file-scan-dir=/etc/php \
--with-openssl \
--with-zlib  \
--with-curl \
--enable-ftp \
--with-gd  \
--with-xmlrpc \
--with-jpeg-dir \
--with-png-dir  \
--with-freetype-dir \
--with-mcrypt=/usr/local/libmcrypt \
--enable-mysqlnd \
--with-mysqli=mysqlnd \
--with-pdo-mysql=mysqlnd  \
--with-mysql-sock=/var/lib/mysql/mysql.sock \
--without-pear \
--enable-bcmath \
--enable-zip \
--enable-mbstring \
#--with-mcrypt \
#--enable-gd-native-ttf \

# php7.2 以后不支持  with-mcrypt, --enable-gd-native-ttf 这两个参数，需要去掉

make && make install

ln -s /usr/local/php/bin/php /usr/local/bin/


phpetc_dir="/etc/php/"


if [ ! -d ${phpetc_dir} ]
then
  mkdir -p ${phpetc_dir}
fi

cp -rf  /usr/local/php/etc/  ${phpetc_dir}

