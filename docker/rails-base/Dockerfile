FROM ruby:2.3
MAINTAINER siarhei.ivanouski@rubyroidlabs.com

RUN apt-get update \
    && apt-get -y install \
      curl wget git ssh

COPY Gemfile .
COPY Gemfile.lock .

RUN bundle install
