#!/bin/bash
#
#   This script is used for ubuntu initialization after vm creatation.
#   It should be execute by root or cloud-init of cloud provider.
#
#   Pay attention to the 
#           !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#           !!!!!! white list 192.168.1.x  !!!!!!
#           !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#                               before execute.
#                                                   -- by Youqing
#                                             2019.09.17 ~ 2019.09.19
#   

echo "[$(date '+%F %T%z')] Start initializing.">/root/init.log
# hostname
grep "^\([0-9]\{1,3\}.\)\{4\}\s*$(hostname)" /etc/hosts||echo "127.0.0.1 $(hostname)">>/etc/hosts

# timezone & timeserver
[ -s /etc/timezone.default ]||cp -p /etc/timezone{,.default}
timedatectl set-timezone UTC
timedatectl set-local-rtc 0
timedatectl set-ntp true
grep '^UTC' /etc/default/rcS&&sed -i 's#^UTC=.*#UTC=yes#g' /etc/default/rcS
grep '^UTC' /etc/default/rcS||echo 'UTC=yes'>>/etc/default/rcS
hwclock --systohc --utc
hwclock --show
# tzselect|dpkg-reconfigure tzdata
apt-get update --fix-missing&&apt-get -y install ntpdate
systemctl stop ntp
ntpdate cn.pool.ntp.org
systemctl start ntp

# cron
rm -f /etc/cron.deny /etc/at.deny 
touch /etc/cron.allow /etc/at.allow 
chmod -R 0600 /etc/crontab /etc/cron.d /etc/{cron.hourly,cron.daily,cron.weekly,cron.monthly}
chmod    0600 /etc/cron.allow /etc/at.allow

# sudo
[ -s /etc/sudoers ]||cp -p /etc/sudoers{,.default}
sed -i '/# Cmnd alias/aCmnd_Alias	DENY = /usr/bin/chattr,/usr/sbin/useradd,/usr/bin/passwd' /etc/sudoers
sed -i 's#%.*#&,!DENY#g' /etc/sudoers
sed -i 's#^\s*%sudo.*#\#&#g' /etc/sudoers
sed -i '/#%sudo/a%sudo ALL=(ALL) NOPASSWD: ALL, !DENY' /etc/sudoers

# ufw
iptables -t filter -I INPUT 1 -p tcp --dport 22 -j ACCEPT
# iptables -t filter -I INPUT 1 -p tcp --dport 32456 -j ACCEPT
[ -s /etc/default/ufw.default ]||cp -p /etc/default/ufw{,.default}
sed -i 's#^IPV6=yes#IPV6=no#g' /etc/default/ufw
ufw allow from 192.168.98.2 to any port 22
ufw allow from 192.168.98.0/24
ufw allow 18888
ufw default deny incoming
ufw enable<<<y

# ssh
apt-get -y install openssh-server
systemctl start ssh;
systemctl enable ssh;
mkdir -pv /root/.ssh
touch /root/.ssh/authorized_keys
cat> /root/.ssh/authorized_keys<<EOL
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQChFpf+inoHrR5EIy+claTtM4z5osrK0yXvng5iwdNfztP/AVt+QVtXDdBoKYC5UGeZbJ76BEnmdXV5Um3D+D1Ni1UtJMTjPIdHG3Vq3fDokW9GD7KhgY4RW1mxhWZOxOaxr1s8OmS4prdwLrMaFbZeOOgKxcYtH9dnIRbvG2Ee9Kw41xj+rl6xVxW5FbwBXCRW3kBJFzASYuDYc/Rb38iWXaS8QsyArl9DWvfGlaBTmUCXocuK2svNc3gNaG9B6SbsXMs6Nk141MyzO+pT1J5XAVD0PdKklQSAhRrC5QOZzNqULl5a0h/0uG2EMJg47M6QyVvJV3iWjwkk4iu44PZL root@ops-jump-01
EOL
cat> /home/ubuntu/.ssh/authorized_keys<<EOL
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQChFpf+inoHrR5EIy+claTtM4z5osrK0yXvng5iwdNfztP/AVt+QVtXDdBoKYC5UGeZbJ76BEnmdXV5Um3D+D1Ni1UtJMTjPIdHG3Vq3fDokW9GD7KhgY4RW1mxhWZOxOaxr1s8OmS4prdwLrMaFbZeOOgKxcYtH9dnIRbvG2Ee9Kw41xj+rl6xVxW5FbwBXCRW3kBJFzASYuDYc/Rb38iWXaS8QsyArl9DWvfGlaBTmUCXocuK2svNc3gNaG9B6SbsXMs6Nk141MyzO+pT1J5XAVD0PdKklQSAhRrC5QOZzNqULl5a0h/0uG2EMJg47M6QyVvJV3iWjwkk4iu44PZL root@ops-jump-01
EOL
[ -s /etc/ssh/sshd_config.default ]||cp -p /etc/ssh/sshd_config{,.default}
cp /etc/ssh/sshd_config{,.$(date '+%F_%T')}
# sed -i 's#^Port 22#\#&#g' /etc/ssh/sshd_config
sed -i 's#^Protocol 1#\#&#' /etc/ssh/sshd_config
sed -i 's#^PasswordAuthentication\s*yes#\#&#' /etc/ssh/sshd_config
sed -i 's#^HostbasedAuthentication\s*yes#\#&#' /etc/ssh/sshd_config
sed -i 's#^PermitRootLogin\s*yes#\#&#' /etc/ssh/sshd_config
sed -i 's#^LogLevel.*#\#&#' /etc/ssh/sshd_config
sed -i 's#^AllowAgentForwarding.*#\#&#' /etc/ssh/sshd_config
sed -i 's#^AllowTcpForwarding.*#\#&#' /etc/ssh/sshd_config
sed -i 's#^X11Forwarding.*#\#&#' /etc/ssh/sshd_config
sed -i 's#^ClientAliveCountMax.*#\#&#' /etc/ssh/sshd_config
sed -i 's#^ClientAliveInterval.*#\#&#' /etc/ssh/sshd_config
sed -i 's#^TCPKeepAlive.*#\#&#' /etc/ssh/sshd_config
sed -i 's#^Compression.*#\#&#' /etc/ssh/sshd_config
sed -i 's#^MaxAuthTries.*#\#&#' /etc/ssh/sshd_config
sed -i 's#^MaxSessions.*#\#&#' /etc/ssh/sshd_config
sed -i 's#^UsePrivilegeSeparation.*#\#&#' /etc/ssh/sshd_config
sed -i 's#^AllowUsers.*#\#&#' /etc/ssh/sshd_config
# grep '^Port\s\+2222' /etc/ssh/sshd_config||echo 'Port 2222'>>/etc/ssh/sshd_config
grep '^Protocol 2' /etc/ssh/sshd_config||echo 'Protocol 2'>>/etc/ssh/sshd_config
grep '^HostbasedAuthentication\s*no' /etc/ssh/sshd_config||echo 'HostbasedAuthentication no'>>/etc/ssh/sshd_config
grep '^PasswordAuthentication no' /etc/ssh/sshd_config||echo 'PasswordAuthentication no'>>/etc/ssh/sshd_config
grep '^PubkeyAuthentication yes' /etc/ssh/sshd_config||echo 'PubkeyAuthentication yes'>>/etc/ssh/sshd_config
grep '^PermitRootLogin prohibit-password' /etc/ssh/sshd_config||echo 'PermitRootLogin prohibit-password'>>/etc/ssh/sshd_config
grep '^PermitEmptyPasswords no' /etc/ssh/sshd_config||echo 'PermitEmptyPasswords no'>>/etc/ssh/sshd_config
grep '^LogLevel VERBOSE' /etc/ssh/sshd_config||echo 'LogLevel VERBOSE'>>/etc/ssh/sshd_config
grep '^IgnoreRhosts no' /etc/ssh/sshd_config||echo 'IgnoreRhosts no'>>/etc/ssh/sshd_config
grep '^PermitUserEnvironment no' /etc/ssh/sshd_config||echo 'PermitUserEnvironment no'>>/etc/ssh/sshd_config
grep '^LoginGraceTime 1m' /etc/ssh/sshd_config||echo 'LoginGraceTime 1m'>>/etc/ssh/sshd_config
grep '^AllowAgentForwarding no' /etc/ssh/sshd_config||echo 'AllowAgentForwarding no'>>/etc/ssh/sshd_config
grep '^AllowTcpForwarding no' /etc/ssh/sshd_config||echo 'AllowTcpForwarding no'>>/etc/ssh/sshd_config
grep '^X11Forwarding no' /etc/ssh/sshd_config||echo 'X11Forwarding no'>>/etc/ssh/sshd_config
grep '^ClientAliveCountMax 3' /etc/ssh/sshd_config||echo 'ClientAliveCountMax 3'>>/etc/ssh/sshd_config
grep '^ClientAliveInterval 60' /etc/ssh/sshd_config||echo 'ClientAliveCountMax 60'>>/etc/ssh/sshd_config
grep '^TCPKeepAlive yes' /etc/ssh/sshd_config||echo 'TCPKeepAlive yes'>>/etc/ssh/sshd_config
grep '^Compression no' /etc/ssh/sshd_config||echo 'Compression no'>>/etc/ssh/sshd_config
grep '^MaxAuthTries 3' /etc/ssh/sshd_config||echo 'MaxAuthTries 3'>>/etc/ssh/sshd_config
grep '^MaxSessions 3' /etc/ssh/sshd_config||echo 'MaxSessions 5'>>/etc/ssh/sshd_config
grep '^UsePrivilegeSeparation SANDBOX' /etc/ssh/sshd_config||echo 'UsePrivilegeSeparation SANDBOX'>>/etc/ssh/sshd_config
grep '^AllowUsers *@192.168.98.2' /etc/ssh/sshd_config||echo 'AllowUsers *@192.168.98.2'>>/etc/ssh/sshd_config

# hosts.allow,hosts.deny
cat >> /etc/hosts.allow <<EOL
sshd:192.168.98.2:allow
*:192.168.98.0:allow
EOL
cat >> /etc/hosts.deny <<EOL
sshd:0.0.0.0:deny
EOL

# mode
chmod -R 0700 /var/spool/cron /root/.ssh/
chmod    0600 /root/.ssh/*
chattr    +ai /root/.ssh/authorized_keys
# chattr    +ai /etc/sudoers
# gcc
[ -f "$(which gcc)" ]&&chmod 700 "$(which gcc)"
[ -L "$(which gcc)" ]&&chmod 700 "$(dirname $(which gcc))/$(readlink $(which gcc))"

# login.defs
[ -s /etc/login.defs.default ]||cp -p /etc/login.defs{,.default}
cp -p /etc/login.defs{,.$(date '+%F_%T')}
cat>>/etc/login.defs<<LOGIN
PASS_MAX_DAYS 	180
PASS_MIN_DAYS 	7
# PASS_MIN_LEN 	16
# PASS_MAX_LEN 	36
UMASK 			027
LOGIN
sed -i 's#^PASS_MAX_DAYS.*#PASS_MAX_DAYS\t180#' /etc/login.defs
sed -i 's#^PASS_MIN_DAYS.*#PASS_MIN_DAYS\t7#g' /etc/login.defs
# sed -i 's#^PASS_MIN_LEN.*#PASS_MIN_LEN\t16#' /etc/login.defs
# sed -i 's#^PASS_MAX_LEN.*#PASS_MAX_LEN\t32#' /etc/login.defs
sed -i 's#^UMASK.*#UMASK\t\t027#' /etc/login.defs
useradd -D -f 180

# ip_local_port_range
echo '4000 65535' >  /proc/sys/net/ipv4/ip_local_port_range
grep '^net.ipv4.ip_local_port_range' /etc/sysctl.conf&&sed -i 's#^net.ipv4.ip_local_port_range.*#net.ipv4.ip_local_port_range = 4000 65535#g' /etc/sysctl.conf
grep '^net.ipv4.ip_local_port_range' /etc/sysctl.conf||echo 'net.ipv4.ip_local_port_range = 4000 65535'>>/etc/sysctl.conf

# /etc/sysctl.conf
[ -s /etc/sysctl.conf.default ]||cp -p /etc/sysctl.conf{,.default}
cp -p /etc/sysctl.conf{,.$(date '+%F_%T')} 
grep '^net.ipv4.conf.all.send_redirects' /etc/sysctl.conf||echo 'net.ipv4.conf.all.send_redirects=0'>>/etc/sysctl.conf
grep '^net.ipv4.conf.all.accept_redirects' /etc/sysctl.conf||echo 'net.ipv4.conf.all.accept_redirects=0'>>/etc/sysctl.conf
grep '^net.ipv6.conf.all.accept_ra' /etc/sysctl.conf||echo 'net.ipv6.conf.all.accept_ra=0'>>/etc/sysctl.conf
grep '^fs.file-max' /etc/sysctl.conf||echo 'fs.file-max=655350'>>/etc/sysctl.conf;
grep '^vm.max_map_count' /etc/sysctl.conf||echo 'vm.max_map_count = 655350'>>/etc/sysctl.conf;
grep pam_limits.so /etc/pam.d/sudo||echo 'session    required     pam_limits.so'>>/etc/pam.d/sudo;
## open file limits
ulimit -HSn 655350
echo 655350 > /proc/sys/fs/file-max;
touch /etc/rc.local;
grep ^ulimit /etc/rc.local||sed -i '/^\s*exit/iulimit -HSn 655350' /etc/rc.local
grep ^ulimit /etc/profile ||echo 'ulimit -HSn 655350' >> /etc/profile
grep ^ulimit /etc/profile &&sed -i 's#^ulimit.*#ulimit -HSn 655350#g' /etc/profile
grep '# File Descriptor Limits' /etc/security/limits.conf>/dev/null 2>&1||cat>> /etc/security/limits.conf<<EOT
# File Descriptor Limits $(date '+%F %T%z')
# *     soft    core    0
*       soft    nproc   163840
*       hard    nproc   163840
*       soft    nofile  655350
*       hard    nofile  655350
root    soft    nofile  655350
root    hard    nofile  655350
EOT
grep '# stack' /etc/security/limits.conf||cat>> /etc/security/limits.conf<<EOT
# stack $(date '+%F %T%z')
*       soft    stack   65000
root    soft    stack   65000
EOT
grep '# Optimize TIME_WAIT' /etc/sysctl.conf>/dev/null 2>&1||cat>>/etc/sysctl.conf<<EOT
# Optimize TIME_WAIT $(date '+%F %T%z')
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_keepalive_time = 1800
net.ipv4.tcp_keepalive_probes = 3
net.ipv4.tcp_keepalive_intvl = 15
EOT
grep '# Backend of SLB' /etc/sysctl.conf>/dev/null 2>&1||cat>>/etc/sysctl.conf<<EOT
# Backend of SLB $(date '+%F %T%z') https://help.aliyun.com/knowledge_detail/39428.html 
# net.ipv4.conf.default.rp_filter = 0
# net.ipv4.conf.all.rp_filter = 0
# net.ipv4.conf.eth0.rp_filter = 0
#   Internal commucation
net.ipv4.conf.default.arp_announce = 2
net.ipv4.conf.all.arp_announce = 2
EOT
# https://help.aliyun.com/knowledge_detail/41334.html
[ -s /etc/security/limits.d/90-nproc.conf ]&&sed -i 's#1024#'$(/usr/bin/free|awk '$1=="Mem:" {print int($2/128)}')'#' /etc/security/limits.d/90-nproc.conf
grep '^# Backlog' /etc/sysctl.conf||cat>>/etc/sysctl.conf<<EOT
# Backlog $(date '+%F %T%z')
net.core.somaxconn = 204800
net.core.netdev_max_backlog = 262144
EOT
echo 204800 >/proc/sys/net/core/somaxconn;
echo 20480 >/proc/sys/net/ipv4/tcp_max_syn_backlog;
sysctl -p

# rsyslog
[ -s /etc/rsyslog.conf.default ]||cp -p /etc/rsyslog.conf{,.default}
cp -p /etc/rsyslog.conf{,.$(date '+%F_$T')}
grep '^$FileCreateMode 0640' /etc/rsyslog.conf||echo '$FileCreateMode 0640'>>/etc/rsyslog.conf

# Disk or LVM @TODO:
# mkdir -pv /opt>>/root/init.log
# for d in /dev/vdb /dev/sdb /dev/xvdb
# do
#     if [[ -e ${d} ]]; then
#         grep ^${d} /etc/fstab||echo data|mkfs.ext4 ${d}; sleep 2|tee -a /root/init.log 2>&1
#         grep ^${d} /etc/fstab||echo -e "${d}\t/opt\text4\tdefaults,nofail 0 2" >>/etc/fstab|tee -a /root/init.log 2>&1
#     fi
# done
mount -a
lsblk>>/root/init.log
blkid>>/root/init.log
df -h>>/root/init.log
fdisk -l>>/root/init.log

# Install Packages
echo 1|dpkg --configure -a|tee -a /root/init.log 2>&1
apt-get -y update|tee -a /root/init.log 2>&1
apt-get -y install software-properties-common bash-completion &&
apt-get -y install ca-certificates&&update-ca-certificates &&
# apt-get -y install vim language-pack-zh-hant language-pack-zh-hans &&
apt-get -y install git zip unzip &&
apt-get -y install mlocate tree telnet net-tools &&
apt-get -y install lsof strace iftop htop iotop nmon screen &&
apt-get -y install python python-dev python3 python3-dev python-pip python3-pip &&
apt-get -y install build-essential libssl-dev libevent-dev libjpeg-dev libxml2-dev libxslt-dev libtool &&
apt-get -y install linux-tools-generic linux-cloud-tools-generic &&
apt-get -y install mysql-client-core-5.7|tee -a /root/init.log 2>&1
# DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-server
apt-get -y autoremove|tee -a /root/init.log 2>&1
systemctl stop agentwatch
chkconfig agentwatch off
apt-get -y remove agentwatch

# dns
[ -L /etc/resolv.conf ]||sed -i '/^nameserver/i\nameserver 8.8.8.8' /etc/resolv.conf
sed -i '/^options/i\nameserver 8.8.8.8' /etc/resolvconf/resolv.conf.d/tail
[ -L /etc/resolv.conf ]&&/sbin/resolvconf -u
systemctl restart systemd-resolved.service
# user config
echo 'SELECTED_EDITOR="/usr/bin/vim"'>/root/.selected_editor
echo "HISTTIMEFORMAT='[%F %T%z] '">>/etc/bash.bashrc
cat>/root/.my.cnf<<EOT
[mysql]
prompt='[\\\R:\\\m:\\\s] \\\u@\\\h:\\\p (\\\d) mysql>\\\_'
[client]
ssl-mode=disable
EOT
mv /etc/default/locale{,.default}
# echo 'LANG="zh_CN.UTF-8"'>/etc/default/locale
echo 'LANG="en_US.UTF-8"'>/etc/default/locale
# systemctl set-default multi-user.target

# upgrade
cat>/root/upgrade.sh<<EOT
#!/bin/bash
chattr -i /etc/sudoers
grep \$(hostname) /etc/hosts||echo -e "\$(ifconfig eth0|grep 'inet addr:\|inet '|grep -v 127|awk '{print $2}'|tr -d 'addr:'|tr '\n' ' ') \$(hostname)">>/etc/hosts
apt-get update --fix-missing&&apt-get -y upgrade
apt-get -y install procps linux-image-generic openssh-client --only-upgrade
apt-get -y dist-upgrade && apt-get -y autoremove
# chattr +i /etc/sudoers
reboot
EOT
chmod +x /root/upgrade.sh
echo "[$(date +%F_%T%z)] Done">>/root/init.log
# install docker & docker-compose   # by hand for now