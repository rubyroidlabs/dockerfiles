FROM rubyroidlabs/rails:5.1.4-3

ARG BRANCH=master
ARG RAILS_ENV=production
ARG REPOSITORY

# Set timezone
RUN ln -sf /usr/share/zoneinfo/US/Pacific /etc/localtime

# Copy deploy keys
RUN mkdir -p ~/.ssh

COPY id_rsa /root/.ssh/id_rsa
COPY known_hosts /root/.ssh/known_hosts

RUN chmod 600 ~/.ssh/id_rsa

# Clone project
RUN git clone -b $BRANCH --single-branch $REPOSITORY /backend

WORKDIR /backend

RUN bundle install
RUN bundle exec rake assets:precompile
