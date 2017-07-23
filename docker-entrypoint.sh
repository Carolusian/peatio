#!/bin/bash

# Start redis-server
# echo "Starting Redis ..."
# redis-server --daemonize yes

echo "Starting RabbitMQ ..."
service rabbitmq-server restart

cd /peatio

echo "Preparing configuration files"
bin/init_config

echo "Initializing database and seed data ..."
bundle exec rake db:setup

echo "Starting all daemons ..."
bundle exec rake daemons:start

echo "Starting peatio app server ..."
bundle exec rails server
