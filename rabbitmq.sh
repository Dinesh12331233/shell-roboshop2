#!/bin/bash

source ./common.sh
app_name=rabbitmq 

check_root 

echo "Please enter rabbitmq password to setup"
read -s RABBITMQ_PASSWORD

cp rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo 
VALIDATE $? "adding rabbitmq repo"

dnf install rabbitmq-server -y &>>$LOG_FILE
VALIDATE $? "installing rabbitmq server"

systemctl enable rabbitmq-server &>>$LOG_FILE
VALIDATE $? "enabling rabbitmq server"

systemctl start rabbitmq-server  &>>$LOG_FILE
VALIDATE $? "starting rabbitmq server" 

rabbitmqctl add_user roboshop $RABBITMQ_PASSWORD  &>>$LOG_FILE #password=roboshop123 
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"



print_time

