# ELK4 Dockerfile by MO
#
# VERSION 16.10.0
FROM ubuntu:16.04 
MAINTAINER MO

# Setup env and apt
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -y && \
    apt-get upgrade -y

# Get and install packages
RUN apt-get install -y logrotate supervisor wget openjdk-8-jdk openjdk-8-jre-headless python-pip && \
    cd /root/ && \
    wget https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/deb/elasticsearch/2.3.4/elasticsearch-2.3.4.deb && \
    wget https://download.elastic.co/logstash/logstash/packages/debian/logstash_2.3.4-1_all.deb && \
    wget https://download.elastic.co/kibana/kibana/kibana_4.5.3_amd64.deb && \
    dpkg -i elasticsearch-2.3.4.deb && \
    dpkg -i logstash_2.3.4-1_all.deb && \
    dpkg -i kibana_4.5.3_amd64.deb && \
    pip install alerta elasticsearch-curator && \
    rm -rf *.deb && \
    apt-get remove wget -y && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add and move files
ADD dist/ /root/dist/
RUN cd /root/dist/ && \
    cp supervisord.conf /etc/supervisor/conf.d/supervisord.conf && \
    cp elasticsearch.yml /etc/elasticsearch/elasticsearch.yml && \
    cp conf/* /etc/logstash/conf.d/ && \
    cp kibana.svg /opt/kibana/src/ui/public/images/kibana.svg && \
    cp kibana.svg /opt/kibana/optimize/bundles/src/ui/public/images/kibana.svg && \
    cp elk.ico /opt/kibana/src/ui/public/images/elk.ico && \
    cp elk.ico /opt/kibana/optimize/bundles/src/ui/public/images/elk.ico && \
    cd / && \
    rm -rf /root/dist

# Setup user, groups and configs
RUN addgroup --gid 2000 tpot && \
    adduser --system --no-create-home --shell /bin/bash --uid 2000 --disabled-password --disabled-login --gid 2000 tpot && \
    sed -i 's/# server.basePath: ""/server.basePath: "\/kibana"/' /opt/kibana/config/kibana.yml && \
    sed -i 's/# kibana.defaultAppId: "discover"/kibana.defaultAppId: "dashboard\/Default"/' /opt/kibana/config/kibana.yml && \
    mkdir -p /usr/share/elasticsearch/config && \
    cp -R /etc/elasticsearch/* /usr/share/elasticsearch/config/ && \
    chown -R tpot:tpot /usr/share/elasticsearch/ && \
    /opt/kibana/bin/kibana plugin -i tagcloud -u https://github.com/stormpython/tagcloud/archive/master.zip && \
    /opt/kibana/bin/kibana plugin -i heatmap -u https://github.com/stormpython/heatmap/archive/master.zip && \
    /usr/share/elasticsearch/bin/plugin install mobz/elasticsearch-head

# Start ELK
CMD ["/usr/bin/supervisord","-c","/etc/supervisor/supervisord.conf"]
