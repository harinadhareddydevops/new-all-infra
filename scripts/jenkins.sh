#!/bin/bash
sudo yum update -y 
sudo  yum install telnet nc net-tools -y 
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
systemctl start amazon-ssm-agent
sudo wget https://dev.mysql.com/get/mysql80-community-release-el9-1.noarch.rpm
sudo dnf install mysql80-community-release-el9-1.noarch.rpm -y
sudo dnf repolist enabled | grep "mysql.*-community.*"
sudo dnf install mysql-community-server -y 
#nodeExporter 
#exporter
cd /opt
sudo wget https://github.com/prometheus/node_exporter/releases/download/v1.4.0-rc.0/node_exporter-1.4.0-rc.0.linux-amd64.tar.gz
 sudo tar -zvxf node_exporter-1.4.0-rc.0.linux-amd64.tar.gz
 cd node_exporter-1.4.0-rc.0.linux-amd64/
nohup ./node_exporter &
#jenkins
sudo yum update -y 
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade
sudo yum install java -y 
sudo yum install jenkins git -y
sudo systemctl enable jenkins
sudo systemctl start jenkins
#maven
sudo yum install git java -y
cd /opt
sudo wget https://dlcdn.apache.org/maven/maven-3/3.9.1/binaries/apache-maven-3.9.1-bin.tar.gz
sudo tar -xvzf apache-maven-3.9.1-bin.tar.gz
sudo ln -s /opt/apache-maven-3.9.1 maven
sudo ln -s /opt/maven/bin/mvn /usr/bin/mvn 
#filebeat installation
sudo rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch
cat <<EOT>> /etc/yum.repos.d/elastic.repo
[elastic-8.x]
name=Elastic repository for 8.x packages
baseurl=https://artifacts.elastic.co/packages/8.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOT
sudo yum install filebeat -y
sudo systemctl start filebeat
sudo systemctl enable filebeat
sudo systemctl restart filebeat