cd /var/www/sites/throneshouse
git pull
rake assets:precompile
sudo /etc/init.d/httpd restart
