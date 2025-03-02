#/bin/bash
ID=$(id -u)
timestamp=$(date +%F-%H-%M-%S)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
logfile="/tmp/$0-$timestamp.log"
exec &>$logfile

validate(){
    if [ $1 -ne 0 ]
    then
    echo -e "$R $2 .....Failed"
    exit 1
    else
    echo -e "$G $2......SUCCESS"
    fi
}

if [ $ID -ne 0 ]
then
echo -e "$R your not root user"
exit 127
else
echo -e "$G your root user"
fi

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
validate $? "installed remirep"

dnf module enable redis:remi-6.2 -y
validate $? "module enabled redis"

dnf install redis -y
validate $? "installed redis"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf
validate $? "give local host access"

systemctl enable redis
validate $? "enabled redis"

systemctl start redis
validate $? "started redis"
