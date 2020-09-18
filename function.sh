#!/bin/bash
isCommandAndInstall()
{
    type  $1
    if [  $? -ne 0 ]
    then
        yum install -y $1
    fi
}


#解压 支持 .gz  bz2 zip
unpack()
{
    if [ ${1##*.} == "bz2" ]
    then
          isCommandAndInstall tar
         tar -jxvf $1
    elif [ ${1##*.} == "gz" ]
    then
        isCommandAndInstall tar
        tar -zxvf $1
    elif [ ${1##*.} == "zip" ]
    then
        isCommandAndInstall unzip
        isCommandAndInstall zip
        unzip $1
    fi
}

# 判断包是否存在  不存在  下载 解压
# param1  package  ww.ag.tag.gz
# param2  downloadurl  http://nginx.org/download/nginx-1.18.0.tar.gz
isPackageAndWgetAndTar()
{
    if [ ! -f $1 ]
    then
        isCommandAndInstall wget
        wget $2
    fi
    unpack $1
}



#创建用户
createUser()
{
    #create user if not exists
    egrep "^$1" /etc/passwd >& /dev/null
    if [ $? -ne 0 ]
    then
        useradd $1 -g $2 -s /sbin/nologin -M
    fi
}

#创建用户组
createGroup()
{
    #create group if not exists
    egrep "^$1" /etc/group >& /dev/null
    if [ $? -ne 0 ]
    then
        groupadd $1
    fi
}



#base  module
yumBaseModule()
{
    yum -y install gcc gcc-c++ zlib zlib-devel openssl openssl-devel pcre-devel libxml2-devel bzip2 bzip2-devel curl-devel freetype-devel libjpeg-devel libpng libpng-devel
}


