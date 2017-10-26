#!/bin/bash

db_check() {
  if [ -f ./docker.db-check.sh ]; then
    . ./docker.db-check.sh
  fi
}

deploy() {
  # copy precompiled assets
  if [ -d /backend/public/assets ]; then
    rm -rf /public/*
    cp -r /backend/public/* /public/
  else
    echo 'ERROR! Assets not found!'
  fi

  db_check

  bundle exec rake db:migrate
  exec bundle exec puma --config config/puma.rb # Do not forget to execute last comand with exec to let puma have PID 1
}

start_dev_env() {
  rm -rf /backend/tmp/pids/server.pid

  db_check

  bundle install
  bundle exec rake db:migrate
  exec bundle exec rails s -b 0.0.0.0 -p 3000 # Do not forget to execute last comand with exec to let puma have PID 1
}

# MAIN

if [ "$RAILS_ENV" = 'production' ] || [ "$RAILS_ENV" = 'staging' ]; then
  deploy
else
  start_dev_env
fi
