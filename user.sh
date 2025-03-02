#!/bin/bash
ID=$(id -u)
timestamp=$(date +%F-%H-%M-%S)
logfile="/tmp/$0-$timestamp-log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
MONGOIP=172.31.36.126

validate(){
if [ $1 -ne 0 ]
then
echo -e "$R $2 ....FAILED "
exit 127
else
echo -e "$G $2 ....SUCCESS"
fi
}

if [ $ID -ne 0 ]
then
echo -e "$R your not root user"
exit 127
else
echo -e "$G your root user"
fi

dnf module disable nodejs -y  &>>$logfile
validate $? "module diabled"

dnf module enable nodejs:18 -y &>>$logfile
validate $? "module enabled"

dnf install nodejs -y &>>$logfile
validate $? "Installed"

id roboshop
if [ $? -ne 0 ]
then
useradd roboshop &>>$logfile
validate $? "useradded"
else
echo "user already exist"
fi 

mkdir -p /app &>>$logfile
validate $? "make app directory->"

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>>$logfile
validate $? "downloaded the application->"

cd /app &>>$logfile
validate $? "Go to app directory->"

unzip -u /tmp/user.zip &>>$logfile
validate $? "unzipped->"

cd /app  &>>$logfile
validate $? "Go to app directory->"

npm install &>>$logfile
validate $? "installed npm->"

cp /home/centos/Roboshop/user.service /etc/systemd/system/user.service &>>$logfile
validate $? "copied user service->"

systemctl daemon-reload &>>$logfile
validate $? "daemon-reloaded->"

systemctl enable user  &>>$logfile
validate $? "enabled user->"

systemctl start user &>>$logfile
validate $? "started user->"

cp /home/centos/Roboshop/mongo.repo /etc/yum.repos.d/mongo.repo &>>$logfile
validate $? "copied mongo repo->"

dnf install mongodb-org-shell -y &>>$logfile
validate $? "installed mongo client->"

mongo --host $MONGOIP </app/schema/user.js &>>$logfile
validate $? "loading user data into mongodb->"