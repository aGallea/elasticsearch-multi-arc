FROM openjdk:8-jdk-buster

ARG ES_VERSION

WORKDIR /usr

# add a non root user
RUN useradd -m elasticuser

# Download extras
RUN apt update
RUN apt install -y curl nano

# Download elasticsearch
#RUN curl -L -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$ES_VERSION.tar.gz
RUN curl -L -O https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-1.6.0.tar.gz
RUN tar -xvf elasticsearch-$ES_VERSION.tar.gz
RUN rm -f elasticsearch-$ES_VERSION.tar.gz
RUN mv elasticsearch-$ES_VERSION elasticsearch

# Add config
ADD elasticsearch.yml /usr/elasticsearch/config/elasticsearch.yml

RUN chown -R elasticuser: .
USER elasticuser

ENV JAVA_HOME=/usr/local/openjdk-18/bin/java
ENV discovery.type=single-node
ENV xpack.security.enabled: false
ENV xpack.ml.enabled: false

RUN cd elasticsearch/bin
RUN chown -R elasticuser: elasticsearch

EXPOSE 9200 9300
CMD cd /usr/elasticsearch/bin/ && ./elasticsearch
