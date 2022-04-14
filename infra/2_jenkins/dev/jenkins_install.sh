#!/bin/bash
#sudo yum update -y 
#sudo yum install wget -y
sudo wget http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo -O /etc/yum.repos.d/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
sudo yum install -y fontconfig 
sudo amazon-linux-extras install java-openjdk11 -y
sudo yum install -y jenkins git
sudo systemctl enable --now jenkins
sudo yum install docker -y
sudo systemctl enable --now docker.service
sudo usermod -aG docker jenkins
#sudo yum install awscli
#Install kubectl
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/bin
#Install eksctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/bin

#yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
#
sudo mkdir -p "/var/lib/jenkins/.kube"
sudo mv /home/ec2-user/kube_config /var/lib/jenkins/.kube/config
sudo chown -R jenkins:jenkins /var/lib/jenkins/
sudo chmod 400 /var/lib/jenkins/.kube/config
sudo systemctl restart jenkins
#ansible
sudo yum install -y python-pip
sudo pip install -y ansible
#helm
sudo wget https://get.helm.sh/helm-v3.8.2-linux-amd64.tar.gz
sudo tar -xzvf helm-v3.8.2-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/bin