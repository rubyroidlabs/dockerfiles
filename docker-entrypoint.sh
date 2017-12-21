#!/bin/bash

BUILD_NAME="$(date +%Y%m%d_%H%M%S)"
ATTEMPTS=10

test_db() {
  for i in $(seq 1 $ATTEMPTS); do
    echo 'SELECT 1+1' | PGPASSWORD=$POSTGRES_PASSWORD psql -h postgres -U $POSTGRES_USER
    if [ $? -eq  0 ]; then
      return
    else
      echo $i
      sleep 1
    fi
  done
  exit 1
}

check_migrations_status() {
  test_db
  for i in $(seq 1 $ATTEMPTS); do
    last_migration_status="$(bundle exec rake db:migrate:status | tail -2 | head -1 | awk '{ print $1 }')"
    if [ "$last_migration_status" == "up" ]; then
      return
    else
      echo $i
      sleep $i
    fi
  done
  exit 1
}

copy_config_files_from_samples() {
  # dev only, for prod they have been already copied onbuild
  for i in $(find config -name "*.sample"); do
    if [ ! -e "${i/.sample/}" ]; then
      cp "$i" "${i/.sample/}"
    fi
  done
}

copy_assets_files() {
  if [ -d /backend/public/admin/assets ]; then
    cd /public
    mkdir "$BUILD_NAME"
    cp -r /backend/public/* "/public/$BUILD_NAME"
    ln -sfn "$BUILD_NAME" current
    cd -
  else
    echo 'ERROR! Assets not found!'
  fi
}

execute_rake_tasks() {
  bundle exec rake payment_plans:update
  bundle exec rake payment_plans:update_lifetime
}

migrate_db() {
  bundle exec rake db:migrate
}

remove_outdated_pids() {
  rm -rf /backend/tmp/pids/server.pid
}

check_gems() {
  bundle check || bundle install
}

create_cron_log_files() {
  if [ ! -f ./log/cron.log ]; then
    touch ./log/cron.log
  fi
  if [ ! -f ./log/error.log ]; then
    touch ./log/error.log
  fi
}

start_server() {
  exec bundle exec puma --config config/puma.rb
}

start_dev_env() {
  copy_config_files_from_samples
  remove_outdated_pids
  test_db
  migrate_db
  exec bundle exec rails s
}

run_application() {
  if [ "$RAILS_ENV" = 'development' ]; then
    start_dev_env
  else
    test_db
    migrate_db
    start_server
  fi
}

run_cron() {
  whenever --update-crontab && cron
  create_cron_log_files
  tail -f /backend/log/*.log
}

run_sidekiq() {
  test_db
  exec bundle exec sidekiq
}

run_helper() {
  if [ "$RAILS_ENV" != 'development' ]; then
    copy_assets_files
  fi
  check_migrations_status
  execute_rake_tasks
}

dispatch() {
  if [ "$RAILS_ENV" = 'development' ]; then
    check_gems
  fi
  case "$SERVICE_NAME" in
    "sidekiq" )
      run_sidekiq
      ;;
    "cron" )
      run_cron
      ;;
    "helper" ) # run rake tasks and copy assets file
      run_helper
      ;;
    * ) # start rails app
      run_application
      ;;
  esac
}

# MAIN

dispatch
