#!/bin/bash
sudo dnf update -y 
sudo dnf install wget -y
sudo wget http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo -O /etc/yum.repos.d/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
sudo dnf install -y java-11-openjdk-devel
sudo dnf install -y jenkins
sudo systemctl enable --now jenkins
sudo firewall-cmd --permanent --add-port=8080/tcp
sudo firewall-cmd --reload