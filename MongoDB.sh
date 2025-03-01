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
echo -e "$Gyour root user"
fi

for package in $@
do
yum list installed $package  &>>$logfile
validate $? "$package is not installed"
yum install $package -y
validate $? "$package installed"
done

