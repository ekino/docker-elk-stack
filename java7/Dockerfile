# --- JAVA ---

FROM ekino/base
MAINTAINER Matthieu Fronton <fronton@ekino.com>

ENV DEBIAN_FRONTEND noninteractive
ENV JAVA_VERSION 7

# install java
RUN apt-get update
RUN apt-get install -y openjdk-${JAVA_VERSION}-jre-headless

# cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

# startup
ADD java7.sh /start.d/05-java7
