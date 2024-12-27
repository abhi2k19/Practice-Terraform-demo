#!/bin/bash
# Update system packages and install dependencies
echo "Updating system packages..." | tee -a /var/log/startup-script.log
sudo apt-get update -y | tee -a /var/log/startup-script.log
sudo apt-get upgrade -y | tee -a /var/log/startup-script.log

# Install Apache web server
echo "Installing Apache..." | tee -a /var/log/startup-script.log
sudo apt-get install apache2 -y | tee -a /var/log/startup-script.log

# Start and enable Apache service
echo "Starting Apache service..." | tee -a /var/log/startup-script.log
sudo systemctl start apache2 | tee -a /var/log/startup-script.log
sudo systemctl enable apache2 | tee -a /var/log/startup-script.log

# Create a simple HTML file to verify the server
echo "Creating index.html..." | tee -a /var/log/startup-script.log
echo "<h1>Welcome to your Terraform provisioned instance!</h1>" | sudo tee /var/www/html/index.html

# Verify Apache is running
echo "Verifying Apache service status..." | tee -a /var/log/startup-script.log
sudo systemctl status apache2 | tee -a /var/log/startup-script.log

# Output instance metadata for validation
echo "Fetching instance metadata..." | tee -a /var/log/startup-script.log
curl http://169.254.169.254/latest/meta-data/ | tee -a /var/log/startup-script.log

echo "Startup script execution completed." | tee -a /var/log/startup-script.log
