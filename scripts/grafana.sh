#!/bin/bash
sudo yum update -y 
sudo yum install telnet nc net-tools httpd -y 
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo systemctl start amazon-ssm-agent
sudo systemctl enable amazon-ssm-agent
sudo wget https://github.com/prometheus/prometheus/releases/download/v2.39.1/prometheus-2.39.1.linux-amd64.tar.gz
tar -xf prometheus-2.39.1.linux-amd64.tar.gz
cd prometheus-2.39.1.linux-amd64/
nohup ./prometheus &
sudo cd /opt
sudo wget https://dl.grafana.com/oss/release/grafana-9.2.1.linux-amd64.tar.gz
tar -xvzf grafana-9.2.1.linux-amd64.tar.gz
chmod -R 755 grafana-9.2.1
cd grafana-9.2.1/bin/
nohup ./grafana-server & 
