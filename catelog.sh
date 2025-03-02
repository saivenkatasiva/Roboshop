#!/bin/bash
ID=$(id -u)
timestamp=$(date +F-%H-%M-%S)
logfile="/tmp/$0-$timestamp.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
MONGOHOST=172.31.36.126

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
exit 127
else
echo -e "$G your root user $N"
fi

dnf module disable nodejs -y &>>$logfile
validate $? "module disabled"

dnf module enable nodejs:18 -y&>>$logfile
validate $? "module denabled"

dnf install nodejs -y&>>$logfile
validate $? "Nodejs installed"

useradd roboshop
validate $? "useradded"

mkdir /app&>>$logfile
validate $? "made app directory"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip
validate $? "Downloaded the application code"

cd /app &>>$logfile
validate $? "go to app directory"

unzip /tmp/catalogue.zip &>>$logfile
validate $? "Unzip"

cd /app &>>$logfile
validate $? "go to app directory"

npm install &>>$logfile
validate $? "npm installed"

cp /home/centos/shell76s/Roboshop/catalogue.service /etc/systemd/system/catalogue.service &>>$logfile
validate $? "copied catalogue.service "

systemctl daemon-reload &>>$logfile
validate $? "daemon-reloadp"

systemctl enable catalogue &>>$logfile
validate $? "enabled catalogue"

systemctl start catalogue &>>$logfile
validate $? "started catalogue"

cp /home/centos/shell76s/Roboshop/mongo.repo /etc/yum.repos.d/mongo.repo
validate $? "copied mongorep"

dnf install mongodb-org-shell -y &>>$logfile
validate $? "installed mongodb-org-shell "

mongo --host $MONGOHOST </app/schema/catalogue.js &>>$logfile
validate $? "loading catalog data inti mongodb "