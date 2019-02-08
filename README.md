# Masternode Install Script

### You can use our Masternode Installer Script to automatically install your Masternode. Please paste these commands into your VPS Ternimal:

    wget https://github.com/hedonproject/Masternode-Installer/releases/download/v1.0/script.sh
    chmod ugo+x script.sh
    ./script.sh

Alternatively, you can use the Guide below:

# Masternode Install Guide

### Requirements:  

VPS from provider line DigitalOcean, Linode, Vultr.  

Recommended VPS size 1 CPU, 2GB RAM.

Desktop wallet with 200 001 HDN.  

SSH Agent such as PuTTY  

### Setup Part 1:  

On your desktop walet, navigate to Tools -> Console. Type in "getnewaddress". Send exactly 200 000 HDN to the address provided.  

This will be your masternode collateral. Wait for atleast 15 confirmations, then proceed to the next step.  

In Tools -> Console, type "masternode outputs". You should see one line corresponding to the transaction ID of your collateral coins with a digit identifier.  
Example: { "6a66ad6011ee363c2d97da0b55b73584fef376dc0ef43137b478aa73b4b906b0": "0" }  

Again in Tools -> Console, type in "masternode genkey". You should see a long key: (masternodeprivkey)  
EXAMPLE: 7xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.
This is your masternode private key, record it to text file, keep it safe, do not share with anyone.  

Save these two strings in a text file, you will need them in the next step. 

Navigate to Tools -> Masternode Configuration File. You should see a line, commented with #. Make a new line with the following format:  

MASTERNODE-NAME VPS-IP:PORT MASTERNODE-PRIV-KEY MASTERNODE-TXID MASTERNODE-TXID-INDETIFIER.  
Ensure you put your data correctly, save and close.  

Navigate to Settings -> Options. On the Wallet tab, check "Show Masternodes Tab", save and restart your wallet.  

NOTE: Each line of the masternode.conf file corresponds to one Masternode. If you want to run more than one Masternode from the same wallet, just repeat the above steps.  

### Setup Part 2:
Log on to your VPS using PuTTY or simular SSH agent.  

You will need to install some dependencies in order to run the Masternode. Please paste the following lines in the terminal one after another:

	sudo apt-get update
    sudo apt-install git -y
    sudo apt-get install build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils -y
    sudo apt-get install libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev -y
    sudo add-apt-repository ppa:bitcoin/bitcoin -y
    sudo apt-get update
    sudo apt-get install libdb4.8-dev libdb4.8++-dev -y
    sudo apt-get install libminiupnpc-dev
    sudo apt-get install libzmq3-dev  
	
Now we have to build the wallet for the masternode. Type the following into the terminal:  

    cd ~/
    git clone https://github.com/hedonproject/Hedon
    chmod 777 -R Hedon
    cd Hedon
    ./autogen.sh
    ./configure
    make
Now, we are going to create the configuration file for the masternode. Type the following into the terminal:  

    cd ~/
    mkdir .hedoncore
    nano .hedoncore/hedon.conf
Paste the following content into the hedon.conf file:

	#----
    rpcuser=YOUR-USERNAME
   	rpcpassword=YOUR-PASSWORD
    rpcallowip=127.0.0.1
    #----
    listen=1
    server=1
    daemon=1
    maxconnections=24
    #--------------------
    masternode=1
    masternodeprivkey=MASTERNODE-PRIVATE-KEY
    externalip=VPS-IP
Save the hedon.conf and navigate to the Hedon daemon:  

    cd ~/Hedon/src
    chmod +x hedond
    chmod +x hedon-cli
    chmod +x hedon-tx
    mv hedon-cli /usr/bin
    mv hedond /usr/bin
    mv hedon-tx /usr/bin
Now you can start the daemon:

    cd ~/
    hedond
Wait for the daemon to synchronize, start your Windows Wallet, navigate to Masternodes -> My Masternodes. At this point, your Masternode should appear with status MISSING. Just select it, and click START MISSING. Now the status should change to PRE_ENABLED, and after some time, you will start to receive HDN rewards. Happy masternoding!
