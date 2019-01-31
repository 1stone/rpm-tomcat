#!/bin/bash

VERSION=$(grep "Version:" /vagrant/tomcat6.spec |cut -d ":" -f2 |tr -d "[:space:]")
RELEASE=$(grep "Release:" /vagrant/tomcat6.spec |cut -d ":" -f2 |tr -d "[:space:]")
ARCH=$(grep "BuildArch:" /vagrant/tomcat6.spec |cut -d ":" -f2 |tr -d "[:space:]")

echo "Version: $VERSION-$RELEASE BuildArch: $ARCH"

# Exclude kernels from update as they may break hgfs under VMWare
yum --exclude=kernel\* update -y
yum -y install policycoreutils-python rpmdevtools
if [ ! -f /root/.rpmmacros ];
then
  rpmdev-setuptree
fi

if [ ! -f /root/rpmbuild/SOURCES/apache-tomcat-$VERSION.tar.gz ];
then
  curl -o  /root/rpmbuild/SOURCES/apache-tomcat-$VERSION.tar.gz http://archive.apache.org/dist/tomcat/tomcat-6/v$VERSION/bin/apache-tomcat-$VERSION.tar.gz
fi

cp "/vagrant/tomcat6."{service,logrotate,conf} "/root/rpmbuild/SOURCES/"
cp "/vagrant/tomcat6.spec" "/root/rpmbuild/SPECS/"

if [ ! -f /vagrant/tomcat6-$VERSION-1.noarch.rpm ];
then
  cd /root/rpmbuild
  rpmbuild --buildroot "/root/rpmbuild/BUILDROOT" /root/rpmbuild/SPECS/tomcat6.spec -bb
  cp /root/rpmbuild/RPMS/noarch/tomcat6-$VERSION-1.noarch.rpm /vagrant
fi
