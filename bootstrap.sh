#!/bin/bash

#Update the main repositories

sudo rm /etc/resolv.conf
sudo ln -s ../run/resolvconf/resolv.conf /etc/resolv.conf
sudo resolvconf -u

sudo apt-get update

sudo apt-get install -y postgresql-9.5 postgresql-9.5-postgis-2.2 postgresql-server-dev-9.5 python-psycopg2 

#Set up the database
sudo -u postgres psql -f /vagrant/db.gen

#Turn off service
sudo systemctl stop postgresql

#Remove old configuration files
sudo rm /etc/postgresql/9.5/main/postgresql.conf
sudo rm /etc/postgresql/9.5/main/pg_hba.conf

#Add the new ones
sudo cp /vagrant/postgresql.conf /etc/postgresql/9.5/main
sudo cp /vagrant/pg_hba.conf /etc/postgresql/9.5/main

sudo -u root chown postgres:postgres /etc/postgresql/9.5/main/postgresql.conf
sudo -u root chown postgres:postgres /etc/postgresql/9.5/main/pg_hba.conf

#Turn start the service and have fun
sudo service postgresql start
