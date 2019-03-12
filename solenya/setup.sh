#####################################################################
#
# Challenge: Solenya
# Author: Jack Sullivan
# Tested on: Ubuntu 16.04.1 - 16.04.5
FLAG_DATA="--He crawls from bowls of cold soup to steal the dreams of wasteful children--"
#
# Steps:
#   1) Find app on port 8000, with a picture of Pickle Rick.
#   2) Find "wubbalubbadubdub" in robots.txt, as a valid URL.
#   3) Browse "/wubbalubbadubdub/" and notice the JS call to "/fingerprint/",
#      with a fixed "Token" header.
#   4) See that JS code is pickling data.
#   5) Send malicious pickle data, with reverse shell payload, to get
#      RCE on the server.
#   6) View the flag in "/srv/app/.flag"
#
# See pickle_bomb.py for a PoC.
#
# References:
#   - https://en.wikipedia.org/wiki/Serialization#Pickle
#   - https://www.synopsys.com/blogs/software-security/python-pickling/
#   - https://github.com/sciyoshi/pickle-js/blob/master/pickle.js
#   - https://github.com/expobrain/javascript-js2png
#   - http://rickandmorty.wikia.com/wiki/Pickle_Rick/Transcript
#
#####################################################################

DEBUG=1

# Absolute path of CWD.
THIS_SCRIPT=`readlink -f $0`
THIS_PATH=`dirname $THIS_SCRIPT`

BASE_PATH="/srv/app"
FLAG_PATH="$THIS_PATH/.flag"


echo "[*] Creating backup user ratface."
sudo useradd --create-home --shell /bin/bash ratface
echo -e "1e1350d9b6308bdb32302ca4eebc87f9\n1e1350d9b6308bdb32302ca4eebc87f9" | sudo passwd ratface
sudo usermod -aG sudo ratface


echo "[*] Creating user jaguar."
sudo useradd --create-home --shell /bin/bash jaguar
echo -e "KatarinaLives\nKatarinaLives" | sudo passwd jaguar


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
sudo iptables -A INPUT -p tcp --dport 8000 -j ACCEPT
sudo bash -c "iptables-save > /etc/iptables/rules.v4"


# Install and configure Python packages.
sudo apt install -y python3 python3-pip
sudo ln -s /usr/bin/pip3 /usr/bin/pip


# Make the service path and copy project.
sed -i "s|chdir.*|chdir=$THIS_PATH|g" $THIS_PATH/uwsgi.ini
sed -i "s|daemonize.*|daemonize=$THIS_PATH\/wsgi.log|g" $THIS_PATH/uwsgi.ini


# Place the world readable flag, and make immutable.
sudo bash -c "echo $FLAG_DATA > $FLAG_PATH"
sudo chmod 444 $FLAG_PATH
sudo chattr +i .flag


# Install packages and start the web app.
echo "[*] Installing pipenv..."
sudo -H pip install --upgrade pipenv
echo "[*] Installing python packages from Pipfile..."
pipenv install Pipfile


# Run web app on boot.
if grep -q "$REG_USER" /etc/rc.local; then
  echo "[*] Persistence already set.";
else
  echo "sudo -u jaguar -H $THIS_PATH/start_app.sh" | sudo tee -a /etc/rc.local
fi
sudo chmod 744 /etc/rc.local


# Start web app.
$THIS_PATH/start_app.sh
