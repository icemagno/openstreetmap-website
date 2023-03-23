FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Install system packages then clean up to minimize image size
RUN apt-get update \
 && apt-get install --no-install-recommends -y \
      build-essential \
      curl \
      default-jre-headless \
      file \
      firefox-geckodriver \
      libarchive-dev \
      libffi-dev \
      libgd-dev \
      libpq-dev \
      libsasl2-dev \
      libvips-dev \
      libxml2-dev \
      libxslt1-dev \
      locales \
      nodejs \
      postgresql-client \
      ruby2.7 \
      ruby2.7-dev \
      tzdata \
      unzip \
      gnupg 

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
 
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y yarn
RUN apt-get -y upgrade

RUN apt-get clean \
 && rm -rf /var/lib/apt/lists/*

ENV DEBIAN_FRONTEND=dialog

# Setup app location
RUN mkdir -p /app
WORKDIR /app

COPY ./ /app/

# Install Ruby packages
ADD Gemfile Gemfile.lock /app/
RUN gem install bundler \
 && bundle install

# Install NodeJS packages using yarn
ADD package.json yarn.lock /app/
ADD bin/yarn /app/bin/
RUN yarn config set ignore-engines true
RUN bundle exec yarn install
RUN touch config/settings.local.yml