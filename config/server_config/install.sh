#! /bin/bash
 
set -e
set -x
 
echo "Exporting env variables"
export DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/config.sh
 
echo "Configuring /etc/hosts ..."
echo "127.0.0.1 localhost localhost.localdomain localhost4 localhost4.localdomain4" > /etc/hosts
echo "::1   localhost localhost.localdomain localhost6 localhost6.localdomain6" >> /etc/hosts
echo "$SERVER_IP_ADDR    $SERVER_FQDN $SERVER_NAME" >> /etc/hosts
 
echo "Configuring /etc/resolv.conf"
echo "search $IPA_DOMAIN" > /etc/resolv.conf
echo "nameserver $SERVER_IP_ADDR" >> /etc/resolv.conf
echo "nameserver $FORWARDER" >> /etc/resolv.conf
echo "nameserver 10.64.63.6" >> /etc/resolv.conf
 
echo "Disabling updates-testing repo ..."
sed -i 's/enabled=1/enabled=0/g' /etc/yum.repos.d/fedora-updates-testing.repo

echo "Downloading IPA rpms ..."
yum install -y freeipa-server freeipa-server-dns bind bind-dyndb-ldap
 
echo "Configuring firewalld ..."
yum install -y firewalld
systemctl enable firewalld
systemctl start firewalld
firewall-cmd --permanent --zone=public --add-port  80/tcp
firewall-cmd --permanent --zone=public --add-port 443/tcp
firewall-cmd --permanent --zone=public --add-port 389/tcp
firewall-cmd --permanent --zone=public --add-port 636/tcp
firewall-cmd --permanent --zone=public --add-port  88/tcp
firewall-cmd --permanent --zone=public --add-port 464/tcp
firewall-cmd --permanent --zone=public --add-port  53/tcp
firewall-cmd --permanent --zone=public --add-port  88/udp
firewall-cmd --permanent --zone=public --add-port 464/udp
firewall-cmd --permanent --zone=public --add-port  53/udp
firewall-cmd --permanent --zone=public --add-port 123/udp
 
firewall-cmd --zone=public --add-port  80/tcp
firewall-cmd --zone=public --add-port 443/tcp
firewall-cmd --zone=public --add-port 389/tcp
firewall-cmd --zone=public --add-port 636/tcp
firewall-cmd --zone=public --add-port  88/tcp
firewall-cmd --zone=public --add-port 464/tcp
firewall-cmd --zone=public --add-port  53/tcp
firewall-cmd --zone=public --add-port  88/udp
firewall-cmd --zone=public --add-port 464/udp
firewall-cmd --zone=public --add-port  53/udp
firewall-cmd --zone=public --add-port 123/udp

echo "Installing IPA server ..."
yum install -y rng-tools
rngd -r /dev/urandom
yum install -y nghttp2
yum install -y libnghttp2*
ipa-server-install --setup-dns --forwarder=$FORWARDER -r $IPA_REALM --hostname=$SERVER_FQDN -n $IPA_DOMAIN -a $PASSWORD -p $PASSWORD -U

echo "Testing kinit"
echo $PASSWORD | kinit admin
