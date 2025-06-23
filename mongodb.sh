#!/bin/bash

source ./common.sh #common.sh file lo unna content antha ee file loki vachestundi
                   #mongodb.sh ane file ni run chesinapudu andulo unna code matrame execeute avutundhi. functions anevi execute kavu.
                   #functions anevi call chesinapudu matrame run avutayi
                   
app_name=mongodb 

check_root 



cp mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "copying mongodb repo"

dnf install mongodb-org -y  &>>$LOG_FILE
VALIDATE $? "Installing mongodb server"

systemctl enable mongod &>>$LOG_FILE
VALIDATE $? "enabling mongodb"

systemctl start mongod &>>$LOG_FILE
VALIDATE $? "starting mongodb"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf 
VALIDATE $? "Editing mongodb conf file for remote connections" 

systemctl restart mongod &>>$LOG_FILE
VALIDATE $? "restarting mongodb" 

print_time





