#!/bin/bash
sudo -i
sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
yum -y install epel-release && yum -y install spawn-fcgi php php-cli mod_fcgid httpd

echo "отключаем SELINUX"
sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
sudo setenforce 0

echo "Создаем конфигурационный файл, настраиваем скрипт и сервис"
touch /etc/sysconfig/watchlog
echo '# Configuration file for my watchlog service 
WORD="ALERT" 
LOG=/var/log/watchlog.log' > /etc/sysconfig/watchlog
mv /tmp/watchlog.sh /opt/watchlog.sh
cp /tmp/watchlog/watchlog.* /etc/systemd/system/
chmod +x /opt/watchlog.sh

echo 'переписываем init на unit'
sed -i 's/^#SOCKET=/SOCKET=/g' /etc/sysconfig/spawn-fcgi
sed -i 's/^#OPTIONS=/OPTIONS=/g' /etc/sysconfig/spawn-fcgi
mv /tmp/spawn-fcgi.service /etc/systemd/system/spawn-fcgi.service

echo 'настраиваем юнит файл apache'
mv /tmp/httpd.service /usr/lib/systemd/system/httpd.service
echo 'OPTIONS=-f conf/first.conf' > /etc/sysconfig/httpd-first
echo 'OPTIONS=-f conf/second.conf' > /etc/sysconfig/httpd-second

cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/first.conf
cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/second.conf
sed -i 's/^Listen 80/Listen 8080/g' /etc/httpd/conf/second.conf
echo 'PidFile /var/run/httpd-second.pid' >> /etc/httpd/conf/second.conf

echo 'запускаем сервисы'
systemctl start watchlog.timer
systemctl start spawn-fcgi.service 
systemctl start httpd@first
systemctl start httpd@second
