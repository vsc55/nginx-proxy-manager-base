FROM nginx:latest

MAINTAINER Jamie Curnow <jc@jc21.com>
LABEL maintainer="Jamie Curnow <jc@jc21.com>"

RUN apt-get update \
  && apt-get install --no-install-recommends --no-install-suggests -y curl gnupg openssl dirmngr apt-transport-https wget ca-certificates git \
  && apt-key adv --fetch-keys https://dl.yarnpkg.com/debian/pubkey.gpg \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list \
  && apt-get update \
  && apt-get install --no-install-recommends --no-install-suggests -y \
        inetutils-ping \
        letsencrypt \
        build-essential \
        apache2-utils \
        yarn

# NodeJS
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean \
    && npm install -g gulp
