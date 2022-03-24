#!/bin/bash
#sudo dnf update -y 
sudo dnf install wget -y
sudo wget http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo -O /etc/yum.repos.d/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
sudo dnf install -y java-11-openjdk-devel
sudo dnf install -y jenkins
sudo systemctl enable --now jenkins

#yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
#
