#!/bin/bash

set -x

export LC_CTYPE=en_US.UTF-8
export AIRFLOW_HOME=/usr/local/airflow

sudo amazon-linux-extras install -y epel

sudo yum update -y

sudo yum install -y python-pip
sudo yum install -y gcc gcc-c++
sudo pip install apache-airflow
sudo pip install apache-airflow[crypto]
sudo pip install apache-airflow[postgres,jdbc]

sudo chown -R ec2-user: ${AIRFLOW_HOME}

airflow initdb

nohup airflow webserver -p 8080 -D
nohup airflow scheduler -D

