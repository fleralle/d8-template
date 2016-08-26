!/usr/bin/env bash

### Install Drupal ###
cd /vagrant/
composer install

### Drush ###
cd /vagrant/web

## Aliases
#mkdir -p ~/.drush
#cp /vagrant/provision/drush/pantheon.aliases.drushrc.php_face2faith ~/.drush/pantheon.aliases.drushrc.php

## Make
#if [ $1 -eq 1 ] || [ ! -f /vagrant/docroot/index.php ]; then
#  /home/vagrant/.composer/vendor/bin/drush make /vagrant/provision/drush/$2.make .
#else
#  echo "drush make already installed, skipping"
#fi


## Site install
echo " "
echo "-- Drush: Site installation --"
echo " "

drush site-install -y standard --db-url=mysql://vagrant:vagrant@localhost/d8_test --site-name="Some" --account-pass="password"

# Enable our custom theme and make it default
#/home/vagrant/.composer/vendor/bin/drush --strict=0 en -y $2
#/home/vagrant/.composer/vendor/bin/drush --strict=0 vset theme_default $2

#drush user-add-role -y administrator admin

# Enable contrib modules.
cd /vagrant/web/modules/contrib

for module in `find *  -maxdepth 0 -type d` 
do
	drush en -y $module
done

#cd /vagrant/docroot

## Custom Modules enable
echo " "
echo "-- Drush: Enabling custom modules --"
echo " "

#cd /vagrant/docroot/sites/all/modules/custom

#for module in `find *  -maxdepth 0 -type d` 
#do
#	/home/vagrant/.composer/vendor/bin/drush en -y $module
#done

#cd /vagrant/docroot

## Features
echo " "
echo "-- Drush: Enabling custom features --"
echo " "

#cd "sites/all/modules/custom/f2f_features"

#for feature in `find *  -maxdepth 0 -type d` 
#do
#	/home/vagrant/.composer/vendor/bin/drush en -y $feature
#done

echo " "
echo "-- Drush: Reverting custom features using @$SITE_ALIAS --"
echo " "

#for feature in `find *  -maxdepth 0 -type d` 
#do
#	/home/vagrant/.composer/vendor/bin/drush fr -y $feature --force
#done

#cd /vagrant/docroot

## Drupal update database
#if [ "X${UpdateDB}" == Xtrue ]; then
#	/home/vagrant/.composer/vendor/bin/drush --strict=0 updb -y
#fi

## Cache clear
echo " "
echo "-- Drush: Cache Clear --"
echo " "
drush cr


## Registry rebuild
echo " "
echo "-- Drush: Registry Rebuild --"
echo " "
#/home/vagrant/.composer/vendor/bin/drush  --strict=0 rr