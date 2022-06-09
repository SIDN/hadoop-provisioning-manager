FROM ubuntu:22.04

USER root

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
 && apt-get install -yq --no-install-recommends \
    build-essential \
    ca-certificates \
    locales \
    python3-dev \
    python3-pip \
    python3-pycurl \
    nodejs \
    npm \
    libkrb5-dev \
    krb5-user \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

ENV SHELL=/bin/bash \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8

RUN  locale-gen $LC_ALL

# always make sure pip is up to date!
RUN python3 -m pip install --no-cache --upgrade setuptools pip

RUN python3 -m pip install jupyterhub

RUN npm install -g configurable-http-proxy \
 && rm -rf ~/.npm

RUN python3 -m pip install jupyterlab notebook

# Install python libs
RUN python3 -m pip install impyla \
  kerberos \
  pyspark \
  numpy \
  scipy \
  matplotlib \
  scikit-learn \
  pandas \
  sqlalchemy \
  jupyterhub-kerberosauthenticator \
  psycopg2-binary

RUN mkdir -p /etc/jupyterhub/tls

# patch jupyterhub-kerberosauthenticator
# see: https://github.com/jupyterhub/kerberosauthenticator/issues/12
RUN sed -i "s/login_url=self.settings\['login_url'\]/login_url=self.settings\['login_url'\],sync=True/" /usr/local/lib/python3.10/dist-packages/kerberosauthenticator/auth.py

EXPOSE 8000

CMD ["jupyterhub", "-f", "/etc/jupyterhub/jupyterhub_config.py"]