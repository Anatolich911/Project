#!/bin/bash 
sudo yum install php php-mysqlnd httpd wget unzip -y
sudo wget  https://wordpress.org/latest.zip -P /var/www/html/
sudo unzip /var/www/html/latest.zip -d /var/www/html/
sudo mv /var/www/html/wordpress/* /var/www/html/
sudo chown -R apache:apache /var/www/html/
sudo setenforce 0 
sudo systemctl restart httpd 
sudo systemctl status httpd 
sudo cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
sudo sed -i "s/'DB_NAME', 'database_name_here'/'DB_NAME', 'wordpress'/g" /var/www/html/wp-config.php
sudo sed -i "s/'DB_USER', 'username_here'/'DB_USER', 'wordpress'/g" /var/www/html/wp-config.php
sudo sed -i "s/'DB_PASSWORD', 'password_here'/'DB_PASSWORD', 'wordpress'/g" /var/www/html/wp-config.php
sudo sed -i "s/'DB_HOST', 'localhost'/'DB_HOST', '${aws_db_instance.default.address}'/g" /var/www/html/wp-config.php
