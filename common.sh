#!/bin/bash

START_TIME=$(date +%s) 
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
LOGS_FOLDER="/var/log/roboshop-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log" 
SCRIPT_DIR=$PWD


mkdir -p $LOGS_FOLDER
echo "Script started executing at: $(date)" | tee -a $LOG_FILE 

app_setup(){
    id roboshop
    if [ $? -ne 0 ]
    then
        useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOG_FILE
        VALIDATE $? "creating roboshop system user"
    else 
        echo -e "system user roboshop already created....$Y skipping $N"
    fi 

    mkdir -p /app 
    VALIDATE $? "creating app directory"

    curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip &>>$LOG_FILE
    VALIDATE $? "downloading $app_name zip file"

    rm -rf /app/*
    cd /app 
    unzip /tmp/$app_name.zip &>>$LOG_FILE
    VALIDATE $? "unzipping $app_name file"

}


nodejs_setup(){
    
    dnf module disable nodejs -y &>>$LOG_FILE
    VALIDATE $? "disabling default nodejs"

    dnf module enable nodejs:20 -y &>>$LOG_FILE
    VALIDATE $? "enabling nodejs:20"

    dnf install nodejs -y &>>$LOG_FILE
    VALIDATE $? "installing nodejs" 

    npm install &>>$LOG_FILE
    VALIDATE $? "Installing dependencies"

}

systemd_setup(){
    cp $SCRIPT_DIR/$app_name.service /etc/systemd/system/$app_name.service 
    VALIDATE $? "copying $app_name service" 

    systemctl daemon-reload &>>$LOG_FILE 
    VALIDATE $? "reloading $app_name" 

    systemctl enable $app_name &>>$LOG_FILE 
    VALIDATE $? "enabling $app_name" 

    systemctl start $app_name
    VALIDATE $? "starting $app_name"
}

#check_root is the function to check the user has root access or not 
check_root(){
    if [ $USERID -ne 0 ]
    then
        echo -e "$R Error: you must have root access to execute the script $N " | tee -a $LOG_FILE
        exit 1
    else 
        echo "you are root user.you have root access" | tee -a $LOG_FILE
    fi 
}


VALIDATE() {

if [ $1 -ne 0 ]
    then 
        echo -e "$2....$R FAILURE $N" | tee -a $LOG_FILE
        exit 1
    else
        echo -e "$2....$G SUCCESS $N" | tee -a $LOG_FILE
    fi         
}

print_time(){
    END_TIME=$(date +%s) 
    TOTAL_TIME=$(($END_TIME - $START_TIME)) 
    echo -e "script executed successfully, $Y time taken is: $TOTAL_TIME seconds $N " 

}