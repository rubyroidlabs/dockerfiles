#!/bin/sh

ATTEMPTS=10

for i in $(seq 1 $ATTEMPTS); do
  echo 'SELECT 1+1' | PGPASSWORD=$POSTGRES_PASSWORD psql -h postgres -U $POSTGRES_USER
  if [ $? -eq  0 ]; then
    break
  else
    echo $i
    sleep $i
  fi
done
