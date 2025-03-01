#!/bin/bash
ID=$(id -u)
timestamp=$(date +F-%H-%M-%S)
logfile="/tmp/$0-$timestamp.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

validate (){
    if [ $1 -ne 0 ]
    then
    echo -e "$R $2 failed"
    exit 127
    else
    echo -e " $G $2 success"
    fi
}
if [ $ID -ne 0 ]
then
echo -e "$R your not root user, please access with root user$N"
else
echo -e "$G your root user $N"
fi

dnf module disable nodejs -y &>>$logfile
validate $? "module disabled"
dnf module enable nodejs:18 -y&>>$logfile
validate $? "module denabled"
dnf install nodejs -y&>>$logfile
validate $? "Nodejs installed"