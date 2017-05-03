# Logstash Dockerfile by MO
#
# VERSION 17.06 
FROM openjdk:8u121-jre-alpine
MAINTAINER MO

# Include dist
ADD dist/ /root/dist/

# Setup env and apt
RUN apk -U add bash wget curl libc6-compat libzmq && \

# Get and install packages
    cd /root/dist/ && \
    wget https://artifacts.elastic.co/downloads/logstash/logstash-5.3.0.tar.gz && \
    tar xvfz logstash-5.3.0.tar.gz -C /usr/share/ && \
    mv /usr/share/logstash-5.3.0 /usr/share/logstash && \

# Add and move files
    cd /root/dist/ && \
    mkdir -p /etc/logstash/conf.d && \
    cp logstash.conf /etc/logstash/conf.d/ && \
    cp elasticsearch-template-es5x.json /usr/share/logstash/vendor/bundle/jruby/1.9/gems/logstash-output-elasticsearch-6.2.6-java/lib/logstash/outputs/elasticsearch/ && \

# Clean up
    apk del wget && \
    rm -rf /root/*

# Healthcheck
HEALTHCHECK --timeout=5s CMD curl -s -XGET 'http://127.0.0.1:9600'

# Start logstash 
CMD ["/usr/share/logstash/bin/logstash", "-f", "/etc/logstash/conf.d/logstash.conf"]
