sudo salt-key --accept-all -y
cd /srv/pillar/
sudo salt '*' saltutil.refresh_pillar
sleep 5
sudo salt '*' state.highstate
sleep 60
sudo cd /home/jurian/script
sudo chmod +x Centrale-Monitor.bash
sudo ./Centrale-Monitor.bash