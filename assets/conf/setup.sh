#!/bin/bash

# General Updates
apt-get update

# Install utils
apt-get install -y vim nano emacs

# Install OpenSSH
apt-get install -y openssh-server &&
mkdir /var/run/sshd &&
echo 'root:admin' | chpasswd &&
sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config &&
sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config &&
echo "export VISIBLE=now" >> /etc/profile &&

# Install PostgreSQL
apt-get install -y python-software-properties software-properties-common postgresql-9.5 postgresql-client-9.5 postgresql-contrib-9.5 &&

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
