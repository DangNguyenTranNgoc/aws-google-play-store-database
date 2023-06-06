#!/bin/bash
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
apt update -y
apt install ansible -y
apt install -y python3-pip
pip3 install pymysql