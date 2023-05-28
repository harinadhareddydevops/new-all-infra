#!/bin/bash
sudo apt update
sudo apt install apache2 -y
sudo systemctl start apache2
sudo systemctl enable apache2
sudo sudo apt install openjdk-11-jre -y
sudo wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo apt-get install apt-transport-https
sudo echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-7.x.list
sudo apt-get update -y
sudo apt-get install filebeat -y
sudo sed -i 's/  enabled: false/  enabled: true/g' /etc/filebeat/filebeat.yml
sudo systemctl enable filebeat.service
sudo systemctl start filebeat.service
sudo systemctl restart filebeat.service
#ssm-agent-installation
sudo apt-get update -y
sudo snap install amazon-ssm-agent --classic
sudo systemctl start snap.amazon-ssm-agent.amazon-ssm-agent.service
sudo systemctl enable snap.amazon-ssm-agent.amazon-ssm-agent.service
#node_exporter-installation
sudo wget https://github.com/prometheus/node_exporter/releases/download/v1.4.0-rc.0/node_exporter-1.4.0-rc.0.linux-amd64.tar.gz
sudo tar -zvxf node_exporter-1.4.0-rc.0.linux-amd64.tar.gz
cd node_exporter-1.4.0-rc.0.linux-amd64/
nohup ./node_exporter &