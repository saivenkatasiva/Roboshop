#!/bin/bash
ID=$(id -u)
timestamp=$(date +%F-%H-%M-%S)
logfile="/tmp/$0-$timestamp.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"


validate(){
if [ $1 -ne 0 ]
then
echo -e " $R failed to install $2 $N"
exit 127
else
echo -e "$G installation success $2 $N"
fi

}

if [ $ID -ne 0 ]
then
echo -e "$R your not root user"
exit 127
else
echo -e "$G your root user"
fi

cp mongo.repo /etc/yum.repos.d/mongo.repo
echo -e "$G copied successfully $N"
dnf install mongodb-org -y &>>$logfile
validate $? "MongoDB success"

systemctl enable mongod &>>$logfile
validate $? "Enables mongodB"

systemctl start mongod &>>$logfile
validate $? "starting MONGODB"

sed -i 's/127.0.0.1/0.0.0.0' /etc/mongod.conf &>>$logfile
validate $? "updating 0.0.0.0,remote access to mongo DB"