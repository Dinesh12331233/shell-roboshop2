#!/bin/bash

source ./common.sh 
check_root 


dnf module list nginx &>>$LOG_FILE
VALIDATE $? "list of modules of nginx"

dnf module disable nginx -y &>>$LOG_FILE
VALIDATE $? "disabling default nginx"

dnf module enable nginx:1.24 -y &>>$LOG_FILE
VALIDATE $? "enabling the required version of nginx"

dnf install nginx -y &>>$LOG_FILE
VALIDATE $? "installing nginx"

systemctl enable nginx &>>$LOG_FILE
VALIDATE $? "enabling nginx"

systemctl start nginx &>>$LOG_FILE
VALIDATE $? "starting nginx"

rm -rf /usr/share/nginx/html/* &>>$LOG_FILE
VALIDATE $? "remove the default content"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>>$LOG_FILE
VALIDATE $? "Downloading frontend code as zip file"

cd /usr/share/nginx/html 

unzip /tmp/frontend.zip &>>$LOG_FILE
VALIDATE $? "unzipping the frontend code"

rm -rf /etc/nginx/nginx.conf &>>$LOG_FILE
VALIDATE $? "remove default nginx configurations"

cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf
VALIDATE $? "copying"

systemctl restart nginx &>>$LOG_FILE
VALIDATE $? "restarting nginx" 


print_time
