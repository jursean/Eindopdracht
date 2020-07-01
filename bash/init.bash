sudo salt-key --accept-all -y
cd /srv/pillar/
sudo git clone https://github.com/jursean/Eindopdracht.git
sleep 5
cd Eindopdracht
sudo mv saltstack/* /srv/pillar/
sudo mv bash/* /home/jurian/script/
cd ../
sudo rm -rf Eindopdracht/
sudo cp /srv/pillar/* /srv/salt/
sudo salt '*' saltutil.refresh_pillar
sleep 5
sudo salt '*' state.highstate
sleep 60
sudo cd /home/jurian/script
sudo chmod +x Centrale-Monitor.bash
sudo ./Centrale-Monitor.bash