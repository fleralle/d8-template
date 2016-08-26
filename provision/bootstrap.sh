#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive
debconf-set-selections <<< "mysql-server mysql-server/root_password password"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password"

# Install LAMP stack
apt-get update -y
apt-get -y install mysql-server mysql-client php5 php5-cli php5-gd php5-curl php5-mysql git sendmail

# Create vagrant user and database
mysql -u root < /vagrant/provision/install-db.sql

# Write apache configuration files
cat <<- EOF > /etc/apache2/sites-available/000-default.conf
	Listen 8000

	<VirtualHost *:80 *:8000>
	  ServerAdmin vagrant@127.0.0.1
	  ServerAlias *.vagrantshare.com

	  DocumentRoot /vagrant/web

	  <Directory /vagrant/web>
	    Options Indexes FollowSymLinks MultiViews
	    AllowOverride All
	    Require all granted
	  </Directory>
	</VirtualHost>
EOF

cat <<- EOF > /etc/apache2/conf-available/server-name.conf
	ServerName 127.0.0.1
EOF

# Enable apache configuration files, mod_rewrite and reload
a2ensite 000-default
a2enconf server-name
a2enmod rewrite
service apache2 reload

# Install Composer
if [ ! -f /usr/local/bin/composer ]; then
	curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
	chmod a+x /usr/local/bin/composer

	# Add Composer's bin dir to path for the vagrant user
	# echo "export PATH=~/.composer/vendor/bin:\$PATH" >> /home/vagrant/.bashrc
fi

# Install Drush via Composer
mkdir -p /home/vagrant/drush8
composer --working-dir=/home/vagrant/drush8 require --no-progress drush/drush:8.*

# Add Drush alias to vagrant user
ln -s /home/vagrant/drush8/vendor/bin/drush /usr/local/bin/drush
#echo "alias drush=/home/vagrant/drush8/vendor/bin/drush" >> /home/vagrant/.bashrc
#cd /home/vagrant
#source .bashrc
