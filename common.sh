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

mkdir -p $LOGS_FOLDER
echo "Script started executing at: $(date)" | tee -a $LOG_FILE

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