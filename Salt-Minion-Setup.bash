#/bin/bash

#Installatie salt-minion
sudo apt-get update
sudo wget -O https://repo.saltstack.com/apt/ubuntu/18.04/amd64/latest/SALTSTACK-GPG-KEY.pub | sudo apt-key add -
sudo apt-get install salt-minion -y

#Aanmaken nieuwe salt-minion config file
sudo touch /etc/salt/minion.d/minion.conf && sudo chmod 777 /etc/salt/minion.d/minion.conf

#Line nummer van de default_include lijn.
linestart=$(grep -nr "default_include" /etc/salt/minion | cut -d : -f1)
lineend=$((linestart+1))
sleep 1

#Uncommenten van de line "default_include" in /etc/salt/minion
sudo sed -i "${linestart},${lineend}s/# *//" /etc/salt/minion

#Salt-master toevoegen in de config file
sudo printf "master: ITV2G-Ubu-37
master_port: 4506" > /etc/salt/minion.d/minion.conf
sleep 1

#Herstarten van de minion services		 
sudo systemctl restart salt-minion

#Minion services toevoegen aan het startup script
sudo systemctl enable salt-minion
