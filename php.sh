#!/bin/bash

#

phppackage="php-7.3.11.tar.gz"
php_install_package_dir=${phppackage%%.tar*}


libzip_package="libzip-1.5.2.tar.gz"
libzip_package_dir=${libzip_package%%.tar*} 
sleep 1
echo -e "\n------解压开始------\n"
if [ -d $php_install_package_dir ]
then
	rm -rf $php_install_package_dir
fi

tar -zxvf $phppackage

echo -e "\n------解压成功------\n"

sleep 2

echo  -e "\n -------开始编译php-------\n"

if [ ! -d $php_install_package_dir ]
then
    echo  -e "\n-----${php_install_package_dir}文件夹不存在------\n"
    exit
fi


yum -y install gcc gcc-c++ openssl openssl-devel  zlib zlib-devel libxml2-devel bzip2 bzip2-devel curl-devel freetype-devel libjpeg-devel libpng libpng-devel

if [ ! -f ${libzip_package} ]
then
	wget https://libzip.org/download/libzip-1.5.2.tar.gz
fi


if [ ! -d $libzip_package_dir ]
then
  tar -zxvf  ${libzip_package}
  yum remove -y libzip
cd ${libzip_package_dir}
  mkdir bulid
  cd bulid
  cmake ..
  make && make install
  cd  ../../$php_install_package_dir
else
  cd $php_install_package_dir
fi

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
#--enable-gd-native-ttf \
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

# php7.2 以后不支持  with-mcrypt, --enable-gd-native-ttf 这两个参数，需要去掉

make && make install

ln -s /usr/local/php/bin/php /usr/local/bin/


phpetc_dir="/etc/php/"


if [ ! -d ${phpetc_dir} ]
then
  mkdir -p ${phpetc_dir}
fi

cp -rf  /usr/local/php/etc/  ${phpetc_dir}

