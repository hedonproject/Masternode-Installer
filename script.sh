#!/bin/bash

INFO='\033[0;36m'
ERROR='\033[0;31m'
SUCCESS='\033[0;32m'
DEFAULT='\033[0m'

printf "${INFO}==================================================================\n"
printf "                  Hedon Masternode Installer\n"
printf "==================================================================${DEFAULT}\n"

printf "${SUCCESS}Choose your Masternode name:${DEFAULT}\n"
read NODENAME
printf "${SUCCESS}Enter your Masternode Private key${DEFAULT}\n"
read NODEKEY
until [ ${#NODEKEY} -ge 51 ] && [ ! ${#NODEKEY} -ge 52 ]; do
             printf "${ERROR}Double check your Masternode Private key and try again:${DEFAULT}\n"
             read NODEKEY
done
printf "${SUCCESS}Enter your Masternode Transaction ID:${DEFAULT}\n"
read NODETX
until [ ${#NODETX} -ge 64 ] && [ ! ${#NODETX} -ge 65 ]; do
             printf "${ERROR}Double check your Masternode Transaction ID and try again:${DEFAULT}\n"
             read NODETX
done
printf "${SUCCESS}Please enter your Masternode Transaction Index:${DEFAULT}\n"
read NODETXI
until [[ "$NODETXI" =~ ^[0-9]+$ ]]; do
             printf "${ERROR}Double check your Masternode Transaction Index and try again:${DEFAULT}\n"
             read NODETXI
done

printf "${SUCCESS}Installing packages and updates${DEFAULT}\n"

sudo apt-get update
sudo add-apt-repository ppa:bitcoin/bitcoin -y
sudo apt-get update
sudo apt-get install ufw -y
sudo apt-get install git -y
sudo apt-get install nano -y
sudo apt-get install pwgen -y
sudo apt-get install dnsutils -y
sudo apt-get install zip unzip -y
sudo apt-get install libzmq3-dev -y
sudo apt-get install libboost-all-dev -y
sudo apt-get install libminiupnpc-dev -y
sudo apt-get install build-essential libssl-dev libminiupnpc-dev libevent-dev -y
sudo apt-get install libdb4.8-dev libdb4.8++-dev -y

PORT="5404"
PASS=$(pwgen -1 20 -n)
VPSIP=$(dig +short myip.opendns.com @resolver1.opendns.com)

printf "${SUCCESS}Setting up locales${DEFAULT}\n"

export LANG="en_US.utf8"
export LANGUAGE="en_US.utf8"
export LC_ALL="en_US.utf8"

printf "${SUCCESS}Checking for old Hedon files${DEFAULT}\n"

cd ~/
if pgrep -x "hedond" > /dev/null
then
    printf "${ERROR}Killing old Hedon process${DEFAULT}\n"
    kill -9 $(pgrep hedond)
fi
if [ -d "Daemon" ]; then
    rm -r Daemon
    printf "${ERROR}Removed old Hedon core${DEFAULT}\n"
fi
if [ -d ".hedoncore" ]; then
    rm -r .hedoncore
    printf "${ERROR}Removed old Hedon data${DEFAULT}\n"
fi

printf "${SUCCESS}Downloading and setting up a new wallet instance${DEFAULT}\n"

cd ~/
wget "https://github.com/hedonproject/Hedon/releases/download/1.0.1.1/hedon-v1.0.1.1-daemon.zip"
unzip ~/hedon-v1.0.1.1-daemon.zip
rm -r ~/hedon-v1.0.1.1-daemon.zip
cd Daemon
chmod ugo+x hedond
chmod ugo+x hedon-cli
chmod ugo+x hedon-tx

printf "${SUCCESS}Setting up ${NODENAME}${DEFAULT}\n"

mkdir ~/.hedoncore

cat <<EOF > ~/.hedoncore/hedon.conf
rpcuser=Hedon
rpcpassword=${PASS}
rpcallowip=127.0.0.1
#----------------------------
listen=1
server=1
daemon=1
maxconnections=64
#----------------------------
masternode=1
masternodeprivkey=${NODEKEY}
externalip=${VPSIP}
EOF

printf "${SUCCESS}Starting up Hedon Daemon${DEFAULT}\n"

sudo ufw allow 5404
sudo ufw allow 5405
~/Daemon/hedond

printf "${SUCCESS}==================================================================${DEFAULT}\n"
printf "${SUCCESS}Paste the following line into masternode.conf of your desktop wallet:${DEFAULT}\n\n"
printf "${ERROR}${NODENAME} ${VPSIP}:${PORT} ${NODEKEY} ${NODETX} ${NODETXI}${DEFAULT}\n\n"
printf "${SUCCESS}Installed with VPS IP ${ERROR}${VPSIP}${SUCCESS} on port ${ERROR}${PORT}${DEFAULT}\n"
printf "${SUCCESS}Installed with Masternode Key ${ERROR}${MNKEY}${DEFAULT}\n"
printf "${SUCCESS}Installed with Masternode TXID ${ERROR}${MNTX}${SUCCESS} index ${ERROR}${MNTXI}${DEFAULT}\n"
printf "${SUCCESS}Installed with RPCUser=${ERROR}Hedon${DEFAULT}\n"
printf "${SUCCESS}Installed with RPCPassword=${ERROR}${PASS}${DEFAULT}\n"
printf "${SUCCESS}==================================================================${DEFAULT}\n"