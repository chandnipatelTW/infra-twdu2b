#!/bin/bash

sudo amazon-linux-extras install -y epel

sudo yum update -y

sudo yum install -y python-pip
sudo yum install -y gcc gcc-c++

sudo pip install apache-airflow
sudo pip install apache-airflow[crypto]
sudo pip install apache-airflow[postgres,jdbc]

export AIRFLOW_HOME=/usr/local/airflow
sudo useradd -ms /bin/bash -d ${AIRFLOW_HOME} airflow

sudo chown -R ec2-user: ${AIRFLOW_HOME}

airflow initdb
nohup airflow webserver -p 8080 >> $AIRFLOW_HOME/logs/webserver.log -D
nohup airflow scheduler >> $AIRFLOW_HOME/logs/scheduler.log -D

