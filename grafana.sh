sudo apt-get install -y adduser libfontconfig1 
wget https://dl.grafana.com/enterprise/release/grafana-enterprise_9.5.3_amd64.deb
sudo dpkg -i grafana-enterprise_9.5.3_amd64.deb
sudo systemctl start grafana-server
sudo systemctl enable grafana-server
