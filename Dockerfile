# ELK5 Dockerfile by MO
#
# VERSION 16.10.0
FROM ubuntu:16.04 
MAINTAINER MO

# Include dist
ADD dist/ /root/dist/

# Setup env and apt
ENV DEBIAN_FRONTEND noninteractive
ENV ES_SKIP_SET_KERNEL_PARAMETERS true
RUN apt-get update -y && \
    apt-get upgrade -y && \

# Get and install packages
    apt-get install -y git logrotate nodejs npm supervisor wget openjdk-8-jdk openjdk-8-jre-headless python-pip && \
    cd /root/dist/ && \
    wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.2.1.deb && \
    wget https://artifacts.elastic.co/downloads/logstash/logstash-5.2.1.deb && \
    wget https://artifacts.elastic.co/downloads/kibana/kibana-5.2.1-amd64.deb && \
    dpkg -i elasticsearch-5.2.1.deb && \
    dpkg -i logstash-5.2.1.deb && \
    dpkg -i kibana-5.2.1-amd64.deb && \
    pip install alerta elasticsearch-curator && \
    ln -s /usr/bin/nodejs /usr/bin/node && \
    cd /opt/ && \
    git clone https://github.com/mobz/elasticsearch-head.git && \
    cd elasticsearch-head && \
    npm install && \
    cd / && \
    npm install grunt -g && \

# Add and move files
    cd /root/dist/ && \
    cp supervisord.conf /etc/supervisor/conf.d/supervisord.conf && \
    cp elasticsearch.yml /etc/elasticsearch/elasticsearch.yml && \
    cp conf/* /etc/logstash/conf.d/ && \
    cp kibana.svg /usr/share/kibana/src/ui/public/images/kibana.svg && \
    cp kibana.svg /usr/share/kibana/src/ui/public/icons/kibana.svg && \
    cp elk.ico /usr/share/kibana/src/ui/public/assets/favicons/favicon.ico && \
#    cp elk.ico /opt/kibana/optimize/bundles/src/ui/public/images/elk.ico && \
    cd / && \

# Setup user, groups and configs
    addgroup --gid 2000 tpot && \
    adduser --system --no-create-home --shell /bin/bash --uid 2000 --disabled-password --disabled-login --gid 2000 tpot && \
    sed -i 's/#server.basePath: ""/server.basePath: "\/kibana"/' /etc/kibana/kibana.yml && \
    sed -i 's/#kibana.defaultAppId: "discover"/kibana.defaultAppId: "dashboard\/Default"/' /etc/kibana/kibana.yml && \
    sed -i 's/#server.host: "localhost"/server.host: "0.0.0.0"/' /etc/kibana/kibana.yml && \
    sed -i 's/\"http\:\/\/localhost\:9200\"/\"https\:\/\/\<FQDN\>\:64297\/es\/\"/' /opt/elasticsearch-head/_site/app.js && \
    mkdir -p /usr/share/elasticsearch/config && \
    cp -R /etc/elasticsearch/* /usr/share/elasticsearch/config/ && \
    chown -R tpot:tpot /usr/share/elasticsearch/ && \
    #/opt/kibana/bin/kibana plugin -i tagcloud -u https://github.com/stormpython/tagcloud/archive/master.zip && \
    #/opt/kibana/bin/kibana plugin -i heatmap -u https://github.com/stormpython/heatmap/archive/master.zip && \
    #/usr/share/elasticsearch/bin/plugin install mobz/elasticsearch-head && \
    #cd /opt/logstash/vendor/bundle/jruby/1.9/gems/logstash-filter-geoip-4.0.4-java/vendor/ && \
    cd /usr/share/logstash/vendor/bundle/jruby/1.9/gems/logstash-filter-geoip-4.0.4-java/vendor/ && \
    #rm GeoLite2-City.mmdb && \
    #wget http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.mmdb.gz && \
    wget http://download.maxmind.com/download/geoip/database/asnum/GeoIPASNum.dat.gz && \
    #gunzip GeoLiteCity.dat.gz && \
    gunzip GeoIPASNum.dat.gz && \
    #mv GeoLiteCity.dat GeoLiteCity-2013-01-18.dat && \
    #mv GeoIPASNum.dat GeoIPASNum-2014-02-12.dat && \

# Clean up
    rm -rf /root/* && \
    apt-get purge wget -y && \
    apt-get autoremove -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Start ELK
CMD ["/usr/bin/supervisord","-c","/etc/supervisor/supervisord.conf"]
