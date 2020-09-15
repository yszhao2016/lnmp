#!/bin/bash
cmake3="cmake-3.12.4.tar.gz"
cmake3_install_dir=${cmake3%%.tar*}
mysqlpackage="mysql-boost-8.0.21.tar.gz"
mysql_install_dir=${mysqlpackage%%.tar*}
mysql_install_dir="mysql-8.0.21"
yum -y install ncurses ncurses-devel bison bison-devel boost boost-devel

if ! [ -x "$(command -v wget)" ]; then
  yum -y install wget
fi


if [ ! -f ${cmake3} ]
then
  echo "${cmake3}不存在";exit;
fi

if ! [ -x "$(command -v cmake)" ]; then
  tar -zxvf $cmake3
  cd $cmake3_install_dir
  ./bootstrap
  gmake && gmake install
  ln -s /usr/local/bin/cmake  /usr/bin/
  cd -
fi


if [ ! -f ${mysqlpackage} ]
then
  wget https://cdn.mysql.com//Downloads/MySQL-8.0/mysql-boost-8.0.21.tar.gz
fi

if [ ! -d ${mysql_install_dir} ];then
   tar -zxvf $mysqlpackage
fi

cd $mysql_install_dir

cmake \
-DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
-DMYSQL_UNIX_ADDR=/usr/local/mysql/mysql.sock \
-DSYSCONFDIR=/etc \
-DSYSTEMD_PID_DIR=/usr/local/mysql \
-DDEFAULT_CHARSET=utf8  \
-DDEFAULT_COLLATION=utf8_general_ci \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_ARCHIVE_STORAGE_ENGINE=1 \
-DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
-DWITH_PERFSCHEMA_STORAGE_ENGINE=1 \
-DMYSQL_DATADIR=/usr/local/mysql/data \
-DDOWNLOAD_BOOST=1 \
-DWITH_BOOST=/usr/local/boost \
-DWITH_SYSTEMD=1 \
-DFORCE_INSOURCE_BUILD=1

make && make install
