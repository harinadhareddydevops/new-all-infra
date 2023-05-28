#!/bin/bash
sudo apt-get update -y
sudo snap install amazon-ssm-agent --classic
sudo systemctl start snap.amazon-ssm-agent.amazon-ssm-agent.service
sudo systemctl enable snap.amazon-ssm-agent.amazon-ssm-agent.service
#installing Elasticsearch
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo apt-get install apt-transport-https
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-7.x.list
sudo apt-get update
sudo apt-get install elasticsearch
sudo sed -i 's/## -Xms4g/-Xms1g/g' /etc/elasticsearch/jvm.options
sudo sed -i 's/## -Xmx4g/-Xmx1g/g' /etc/elasticsearch/jvm.options
sudo systemctl start elasticsearch.service
sudo systemctl enable elasticsearch.service
#installing Kibana
sudo apt-get install kibana
sudo systemctl start kibana.service
sudo systemctl enable kibana.service
sudo sed -i 's/#server.host: "localhost"/server.host: "0.0.0.0"/g' /etc/kibana/kibana.yml
sudo systemctl restart kibana.service
sudo sed -i 's/#network.host: 192.168.0.1/network.host: 0.0.0.0/g' /etc/elasticsearch/elasticsearch.yml
sed -i 's/#discovery.seed_hosts:/discovery.seed_hosts:/g' /etc/elasticsearch/elasticsearch.yml
sed -i 's/"host1", "host2"/"127.0.0.1"/g' /etc/elasticsearch/elasticsearch.yml
sudo systemctl restart elasticsearch.service