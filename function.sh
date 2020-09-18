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
    if [ ${1##*.} eq bz2 ]
    then
          isCommandAndInstall tar
         tar -jxvf $1
    else if [ ${1##*.} eq gz ]
    then
        isCommandAndInstall tar
        tar -zxvf $1
    else if [${1##*.} eq zip ]
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
    if[ ! -f $1 ]
    then
        isCommandAndInstall wget
        wget $2
    fi
    unpack $1
}


#base  module
yumBaseModule()
{
    yum -y install gcc gcc-c++ zlib zlib-devel openssl openssl-devel pcre-devel
}


