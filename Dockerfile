# ELK4 Dockerfile by MO
#
# VERSION 16.03.2
FROM ubuntu:14.04.3
MAINTAINER MO

# Setup env and apt
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -y && \
    apt-get dist-upgrade -y

# Get and install packages
RUN apt-get install -y supervisor wget openjdk-7-jdk openjdk-7-jre-headless python-pip && \
    cd /root/ && \
    wget https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/deb/elasticsearch/2.1.0/elasticsearch-2.1.0.deb && \
    wget https://download.elastic.co/logstash/logstash/packages/debian/logstash_2.1.1-1_all.deb && \
    wget https://download.elastic.co/kibana/kibana/kibana-4.3.0-linux-x64.tar.gz && \
    dpkg -i elasticsearch-2.1.0.deb && \
    dpkg -i logstash_2.1.1-1_all.deb && \
    mkdir -p /opt/kibana/ /usr/share/elasticsearch/config/ /data/ && \
    tar -xzf kibana-4.3.0-linux-x64.tar.gz && mv kibana-4.3.0-linux-x64/* /opt/kibana/ && \
    rm -rf kibana-4.3.0-linux-x64 kibana-4.3.0-linux-x64.tar.gz elasticsearch-2.1.0.deb logstash_2.1.1-1_all.deb && \
    pip install elasticsearch-curator

# Setup user, groups and configs
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD elasticsearch.yml /etc/elasticsearch/elasticsearch.yml
ADD logstash.conf /etc/logstash/conf.d/logstash.conf
ADD kibana.svg /opt/kibana/src/ui/public/images/
ADD kibana.svg /opt/kibana/optimize/bundles/src/ui/public/images/
RUN addgroup --gid 2000 tpot && \
    adduser --system --no-create-home --shell /bin/bash --uid 2000 --disabled-password --disabled-login --gid 2000 tpot && \
    sed -i 's/# server.port: 5601/server.port: 8080/' /opt/kibana/config/kibana.yml && \
    sed -i 's/# kibana.defaultAppId: "discover"/kibana.defaultAppId: "dashboard\/Default"/' /opt/kibana/config/kibana.yml && \
    cp /etc/elasticsearch/*.yml /usr/share/elasticsearch/config/ && \
    chown -R tpot:tpot /usr/share/elasticsearch/ /data && \
    chmod -R 760 /data
    #/opt/kibana/bin/kibana plugin --install elastic/sense && \
    #/opt/kibana/bin/kibana plugin --remove sense

# Clean up
RUN apt-get remove wget -y && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Start ELK
CMD ["/usr/bin/supervisord"]
