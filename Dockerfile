# Nginx Build Image
FROM vsc55/nginx_ldap as builder

RUN apt-get update
RUN apt-get install -y libpcre3-dev libssl-dev zlib1g-dev wget build-essential

WORKDIR /tmp
RUN wget "https://www.openssl.org/source/openssl-1.1.1b.tar.gz"
RUN tar xzf openssl-1.1.1b.tar.gz
WORKDIR /tmp/openssl-1.1.1b
RUN ./config
RUN make test

# Final docker image
FROM vsc55/nginx_ldap

MAINTAINER Jamie Curnow <jc@jc21.com>
LABEL maintainer="Jamie Curnow <jc@jc21.com>"

RUN apt-get update \
  && apt-get update \
  && apt-get install --no-install-recommends --no-install-suggests -y build-essential \
  && apt-get clean

# Openssl custom
COPY --from=builder /tmp/openssl-1.1.1b /tmp/openssl-1.1.1b
WORKDIR /tmp/openssl-1.1.1b
RUN make install \
    && ldconfig \
    && openssl version \
    && rm -rf /tmp/openssl-1.1.1b

RUN apt-get update \
  && apt-get install --no-install-recommends --no-install-suggests -y curl gnupg dirmngr apt-transport-https wget ca-certificates git \
  && apt-key adv --fetch-keys https://dl.yarnpkg.com/debian/pubkey.gpg \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list \
  && apt-get update \
  && apt-get install --no-install-recommends --no-install-suggests -y \
        inetutils-ping \
        letsencrypt \
        apache2-utils \
        yarn \
  && apt-get clean

# NodeJS
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean
