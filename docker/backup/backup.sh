#! /bin/sh

BACKUP_TIMESTAMP="$(date +%Y%m%d_%H%M%S)"

PGPASSWORD=$POSTGRES_PASSWORD pg_dump -h $POSTGRES_HOST -U $POSTGRES_USER -Fc $POSTGRES_DB > $BACKUP_TIMESTAMP.dump

if [ -f $BACKUP_TIMESTAMP.dump ]; then
  aws s3 cp $BACKUP_TIMESTAMP.dump s3://$S3_BUCKET_NAME/
else
  exit 1
fi
