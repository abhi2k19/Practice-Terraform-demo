#!/bin/bash

# Log file location
LOG_FILE="/var/log/user_data.log"

# Update and upgrade system packages
echo "Updating system packages..." | tee -a $LOG_FILE
sudo apt-get update -y && sudo apt-get upgrade -y >> $LOG_FILE 2>&1

# Install necessary packages (e.g., Apache web server)
echo "Installing Apache..." | tee -a $LOG_FILE
sudo apt-get install apache2 -y >> $LOG_FILE 2>&1

# Start and enable Apache service
echo "Starting Apache service..." | tee -a $LOG_FILE
sudo systemctl start apache2 >> $LOG_FILE 2>&1
sudo systemctl enable apache2 >> $LOG_FILE 2>&1

# Create a sample webpage for validation
echo "Creating a sample webpage..." | tee -a $LOG_FILE
echo "<html><body><h1>Instance Successfully Created</h1></body></html>" | sudo tee /var/www/html/index.html >> $LOG_FILE 2>&1

# Validate Apache installation and webpage availability
echo "Validating Apache service..." | tee -a $LOG_FILE
if systemctl status apache2 | grep "active (running)" > /dev/null; then
    echo "Apache is running successfully." | tee -a $LOG_FILE
else
    echo "Apache failed to start." | tee -a $LOG_FILE
fi

# Fetch instance metadata for verification
echo "Fetching instance metadata..." | tee -a $LOG_FILE
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
echo "Instance ID: $INSTANCE_ID" | tee -a $LOG_FILE
echo "Public IP: $PUBLIC_IP" | tee -a $LOG_FILE

# Final log entry
echo "User data script execution completed." | tee -a $LOG_FILE

