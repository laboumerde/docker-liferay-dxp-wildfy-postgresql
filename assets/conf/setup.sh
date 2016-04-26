#!/bin/bash

# General Updates
apt-get update

# Install utils
apt-get install -y vim nano emacs

# Install OpenSSH
apt-get install -y openssh-server &&
mkdir /var/run/sshd &&
echo 'root:admin' | chpasswd &&
sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config &&
sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd &&
echo "export VISIBLE=now" >> /etc/profile &&

# Install PostgreSQL
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8 &&
echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" > /etc/apt/sources.list.d/pgdg.list &&
apt-get install -y python-software-properties software-properties-common postgresql-9.3 postgresql-client-9.3 postgresql-contrib-9.3 &&

# Install JDK from /assets/packages/
tar -zxvf /assets/packages/jdk* -C /opt/ &&
ln -s /opt/jdk* /opt/jdk &&
echo "export JAVA_HOME=/opt/jdk" >> /root/.bashrc &&
echo "export PATH=$PATH:/opt/jdk/bin" >> /root/.bashrc &&
export JAVA_HOME=/opt/jdk &&
export PATH=$PATH:/opt/jdk/bin &&

# Install Liferay from /assets/packages/
apt-get install -y unzip &&
unzip /assets/packages/liferay* -d /opt/ &&
ln -s /opt/liferay* /opt/liferay &&
ln -s /opt/liferay/wildfly* /opt/liferay/wildfly &&

# Configure Liferay
mkdir -p /opt/liferay/deploy &&
cp /assets/conf/liferay/portal-ext.properties /opt/liferay/ &&
mkdir -p /opt/liferay/data && cp -R /assets/conf/liferay/data/* /opt/liferay/data/ &&
cp -R /assets/conf/liferay/wildfly/* /opt/liferay/wildfly/ &&

# Cleaning /assets/packages
rm -rf /assets/packages &&

# Exit
exit $?
