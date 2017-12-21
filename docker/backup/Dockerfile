FROM postgres:10-alpine

RUN apk update \
  && apk add py-pip \
  && pip install awscli --upgrade

COPY backup.sh /etc/periodic/daily/backup.sh

RUN chmod +x /etc/periodic/daily/backup.sh

CMD [ "crond", "-f" ]
