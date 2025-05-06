url --url https://repo.almalinux.org/almalinux/9.5/BaseOS/x86_64/kickstart/

text
skipx
eula --agreed
firstboot --disabled
lang en_US.UTF-8
keyboard us
timezone ${timezone}

rootpw ${root_password}

network  --bootproto=dhcp --ipv6=auto --activate
network  --hostname=localhost.localdomain

clearpart --all --initlabel
ignoredisk --only-use=sda
part / --fstype="ext4" --grow --size=1
bootloader --location=mbr --boot-drive=sda

services --disabled="kdump" --enabled="sshd,rsyslog,chronyd"

sshkey --username=root '${ssh_public_key}'

%packages --ignoremissing
@^minimal-environment
-iwl*firmware
%end

reboot

%post

yum update -y

sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers
echo "PermitRootLogin yes" > /etc/ssh/sshd_config.d/00-allow-root-ssh.conf

yum clean all
%end