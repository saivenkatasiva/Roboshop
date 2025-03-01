#!/bin/bash
ID=$(id -u)
timestamp=$(date +F-%H-%M-%S)
logfile="/tmp/$0-$timestamp.log"
R="\e[32m"
G="\e[33m"
Y="\e[34m"
N="\e[0m"

validate (){
    if [ $1 -ne 0 ]
    then
    echo -e "$R $2 failed"
    else
    echo -e " $G $2 success"
}
if [ $ID -ne 0 ]
then
echo -e "$R your not root user, please access with root user$N"
else
echo -e "$G your root user $N"
fi

dnf module disable nodejs -y &>>$logfile
validate $? "module disabled"