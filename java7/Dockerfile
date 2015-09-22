# --- JAVA ---

FROM ekino/base
MAINTAINER Matthieu Fronton <fronton@ekino.com>

ENV DEBIAN_FRONTEND noninteractive
ENV JAVA_VERSION 7

# install java
RUN apt-get update && apt-get install -y software-properties-common python-software-properties
RUN echo oracle-java${JAVA_VERSION}-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
RUN add-apt-repository -y ppa:webupd8team/java
RUN apt-get update && apt-get install -y oracle-java7-installer

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-7-oracle

# Create java user
RUN groupadd -g 42311 java && useradd -g 42311 -u 42311 -d /home/java -m -s /bin/bash java

# Install sdkman (formerly gvm)
USER java
WORKDIR /home/java
RUN curl -s get.sdkman.io | bash

# cleanup
USER root
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /var/cache/oracle-jdk7-installer

# startup
ADD java7.sh /start.d/05-java7
