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

output1=httpd-logs
ftype=tar
size=$(sudo du -sh /tmp/${myname}-httpd-logs-${timestamp}.tar | awk '{ print $1 }')

sudo echo -e "$output1\t$timestamp\t$ftype\t$size" >> /root/Automation_Project/stage.txt

sudo echo "Log-Type Time-Created Type Size"  | awk '{print $1,"\t",$2,"\t",$3,"\t",$4}' > /root/Automation_Project/firstrow.txt

sudo ls -la /var/www/html | grep inventory.html
if [ $? -eq 0 ]; then
awk 'BEGIN {
    split("120,190,60,50,", widths, ",")
    print "<style>\
        .my_table {font-size:12.0pt; font-family:\"Verdana\",\"sans-serif\"; }\n\
        .my_table th {text-align: left;}\
    </style>"
    print "<table class=\"my_table\">"
}
NR == 1{
    print "<tr class=\"header\">"
    tag = "th"
}
NR != 1{
    print "<tr>"
    tag = "td"
}
{
    for(i=1; i<=NF; ++i) print "<" tag " width=\"" widths[i] "\">" $i "</" tag ">"
    print "</tr>"
}
END { print "</table>"}' /root/Automation_Project/firstrow.txt > /var/www/html/inventory.html
else
sudo touch /var/www/html/inventory.html
sudo chmod 777 /var/www/html/inventory.html
awk 'BEGIN {
    split("120,190,60,50,", widths, ",")
    print "<style>\
        .my_table {font-size:12.0pt; font-family:\"Verdana\",\"sans-serif\"; }\n\
        .my_table th {text-align: left;}\
    </style>"
    print "<table class=\"my_table\">"
}
NR == 1{
    print "<tr class=\"header\">"
    tag = "th"
}
NR != 1{
    print "<tr>"
    tag = "td"
}
{
    for(i=1; i<=NF; ++i) print "<" tag " width=\"" widths[i] "\">" $i "</" tag ">"
    print "</tr>"
}
END { print "</table>"}' /root/Automation_Project/firstrow.txt > /var/www/html/inventory.html
fi

awk 'BEGIN {
    split("120,190,60,60,", widths, ",")
    print "<style>\
        .my_table {font-size:12.0pt; font-family:\"Verdana\",\"sans-serif\"; }\n\
        .my_table th {text-align: left;}\
    </style>"
    print "<table class=\"my_table\">"
}
NR == 1{
    print "<tr>"
    tag = "td"
}
NR != 1{
    print "<tr>"
    tag = "td"
}
{
    for(i=1; i<=NF; ++i) print "<" tag " width=\"" widths[i] "\">" $i "</" tag ">"
    print "</tr>"
}
END { print "</table>"}' /root/Automation_Project/stage.txt >> /var/www/html/inventory.html


sudo systemctl status cron

if [ $? -eq 0 ]; then
  echo "**cron service is running**"
else
  sudo service cron start
fi

sudo ls -la /etc/cron.d | grep automation
if [ $? -eq 0 ]; then
sudo echo "0 10 * * * root /root/Automation_Project/automation.sh" > /etc/cron.d/automation
else
sudo touch /etc/cron.d/automation
sudo echo "0 10 * * * root /root/Automation_Project/automation.sh" > /etc/cron.d/automation
fi

