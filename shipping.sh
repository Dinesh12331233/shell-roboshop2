#!/bin/bash

source ./common.sh 
app_name=shipping 

check_root 
echo "Please enter root password to setup"
read -s MYSQL_ROOT_PASSWORD

app_setup
maven_setup 
systemd_setup

dnf install mysql -y &>>$LOG_FILE
VALIDATE $? "installing mysql" 

mysql -h mysql.deepthi.tech -u root -p$MYSQL_ROOT_PASSWORD -e 'use cities'
if [ $? -ne 0 ] 
then
    mysql -h mysql.deepthi.tech -uroot -p$MYSQL_ROOT_PASSWORD < /app/db/schema.sql &>>$LOG_FILE
    mysql -h mysql.deepthi.tech -uroot -p$MYSQL_ROOT_PASSWORD < /app/db/app-user.sql &>>$LOG_FILE
    mysql -h mysql.deepthi.tech -uroot -p$MYSQL_ROOT_PASSWORD < /app/db/master-data.sql &>>$LOG_FILE
    VALIDATE $? "loading data into MYSQL"
else 
    echo -e "Data is already loaded into MYSQL... $Y skipping $N "
fi
systemctl restart shipping &>>$LOG_FILE
VALIDATE $? "restarting shipping"

print_time
