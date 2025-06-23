#!/bin/bash

source ./common.sh
app_name=redis 

check_root 

dnf module disable redis -y &>>$LOG_FILE
VALIDATE $? "disabling default version of redis"

dnf module enable redis:7 -y &>>$LOG_FILE
VALIDATE $? "enabling redis:7 version of redis"

dnf install redis -y &>>$LOG_FILE 
VALIDATE $? "installing redis"

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf &>>$LOG_FILE 
VALIDATE $? "editing redis.conf to accept remote connections" 

systemctl enable redis &>>$LOG_FILE 
VALIDATE $? "enabling redis"

systemctl start redis &>>$LOG_FILE 
VALIDATE $? "starting redis" 

print_time

