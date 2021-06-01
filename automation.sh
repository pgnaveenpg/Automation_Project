#!/bin/bash
myname=Naveen
timestamp=$(date '+%d%m%Y-%H%M%S')
s3_bucket=npgtest1

sudo apt update -y

sudo dpkg --status apache2
if [ $? -ne 0 ]; then
    sudo apt install apache2 -y
fi

sudo systemctl is-active --quiet apache2
if [ $? -eq 0 ]; then
    echo "apache2 Service is running"
else
    sudo systemctl start apache2
fi

sudo systemctl is-enabled apache2.service
if [ $? -eq 0 ]; then
    echo "apache2 Service is Enabled"
else
    sudo systemctl enable apache2
fi

cd /var/log/apache2; tar -cvf - *.log > /tmp/${myname}-httpd-logs-${timestamp}.tar

aws s3 cp /tmp/${myname}-httpd-logs-${timestamp}.tar s3://${s3_bucket}/${myname}-httpd-logs-${timestamp}.tar
