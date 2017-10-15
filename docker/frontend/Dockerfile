FROM rubyroidlabs/angular-cli:1.4.7-1-alpine

ARG BRANCH=master
ARG ENV=production
ARG REPOSITORY

# Copy deploy keys
RUN mkdir -p ~/.ssh

COPY id_rsa /root/.ssh/id_rsa
COPY known_hosts /root/.ssh/known_hosts

RUN chmod 600 ~/.ssh/id_rsa

# Clone project
RUN git clone -b $BRANCH --single-branch $REPOSITORY /frontend

WORKDIR /frontend

RUN yarn install
