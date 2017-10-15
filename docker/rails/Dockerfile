FROM rubyroidlabs/ruby:2.4.2-xenial

RUN apt-get update \
    && apt-get -y install \
      tzdata \
      build-essential libpq-dev postgresql-client \
      libxrender1 imagemagick libmagickwand-dev pkg-config \
      curl wget git ssh ffmpeg nodejs cron

COPY Gemfile .
COPY Gemfile.lock .

RUN bundle install && bundle update
