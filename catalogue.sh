#!/bin/bash

source ./common.sh 
app_name=catalogue 

check_root
app_setup
nodejs_setup
systemd_setup

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo
dnf install mongodb-mongosh -y &>>$LOG_FILE
VALIDATE $? "installing mongodb client"

mongosh --host mongodb.deepthi.tech </app/db/master-data.js &>>$LOG_FILE
VALIDATE $? "Loading data into mongodb" 

print_time
