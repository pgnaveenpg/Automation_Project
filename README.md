# Automation_Project
Upgrad assignment 1
The script automation.sh perform an update of the package details and the package list at the start of the script.
Installs the apache2 package if it is not already installed
Ensures that the apache2 service is runningand also ensures that the apache2 service is enabled.
Script creates a tar archive of apache2 access logs and error logs that are present in the /var/log/apache2/ directory and place the tar into the /tmp/ directory.
It creates a tar of only the .log files (for example access.log) and not any other file type.
Finally script uploads the abouve created tar file to a S3 bucket.

