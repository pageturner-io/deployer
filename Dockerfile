FROM ruby:2.3.1

MAINTAINER Bruno Abrantes <bruno@brunoabrantes.com>

# Prepare Users
RUN adduser --disabled-password --gecos "" app

# Prepare folders
RUN mkdir -p /home/app/deployer

# Add entrypoint script
ADD ./script/entrypoint.sh /usr/local/bin/entrypoint

# Run Bundle in a cache efficient way
WORKDIR /tmp
ADD Gemfile /tmp/
ADD Gemfile.lock /tmp/
RUN bundle install --without development test

# Add our app
ADD . /home/app/deployer
RUN chown -R app:app /home/app

# Clean up when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /home/app/deployer

ENTRYPOINT ["entrypoint"]
