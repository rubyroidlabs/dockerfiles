FROM angular2-base:latest
MAINTAINER siarhei.ivanouski@rubyroidlabs.com

ARG branch
ARG repository

RUN mkdir -p ~/.ssh \
    && echo "
      !!!! HERE SHOULD BE PRIVATE RSA KEY !!!!
    " > ~/.ssh/id_rsa \
    && chmod 600 ~/.ssh/id_rsa \
    && echo "
      !!!! HERE SHOULD BE KNOWN_HOSTS ENTRIES FOR GIT SERVER (github, gitlab, bitbucket...) !!!!
    " > ~/.ssh/known_hosts

WORKDIR /

RUN git clone -b $branch --single-branch $repository frontend

WORKDIR /frontend

RUN npm install
RUN typings install
