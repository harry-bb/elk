# ELK Dockerfile by MO 
#
# VERSION 0.42
FROM ubuntu:14.04.3
MAINTAINER MO

# Setup env and apt
ENV DEBIAN_FRONTEND noninteractive
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
RUN apt-get update -y && \
    apt-get dist-upgrade -y

# Get and install packages 
RUN apt-get install -y apache2 supervisor wget openjdk-7-jdk openjdk-7-jre-headless python-pip && \ 
    cd /root/ && \
    wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.4.4.deb && \
    wget https://download.elasticsearch.org/logstash/logstash/packages/debian/logstash_1.4.2-1-2c0f5a1_all.deb && \
    wget https://download.elasticsearch.org/kibana/kibana/kibana-3.1.2.tar.gz && \
    dpkg -i elasticsearch-1.4.4.deb && \
    dpkg -i logstash_1.4.2-1-2c0f5a1_all.deb && \
    tar -xzf kibana-3.1.2.tar.gz && mv kibana-3.1.2/* /var/www/html/ && \
    rm -rf kibana-3.1.2 elasticsearch-1.4.4.de logstash_1.4.2-1-2c0f5a1_all.deb kibana-3.1.2.tar.gz && \
    pip install elasticsearch-curator

# Setup user, groups and configs
RUN addgroup --gid 2000 tpot && \
    adduser --system --no-create-home --shell /bin/bash --uid 2000 --disabled-password --disabled-login --gid 2000 tpot && \
    sed -i 's#elasticsearch: "http://"+window.location.hostname+":9200",#elasticsearch: "http://"+window.location.hostname+":8080/elasticsearch/",#' /var/www/html/config.js && \
    sed -i 's#Listen 80#Listen 8080#' /etc/apache2/ports.conf && \
    a2enmod proxy proxy_http
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD elasticsearch.yml /etc/elasticsearch/elasticsearch.yml
ADD 000-default.conf /etc/apache2/sites-available/000-default.conf 
ADD logstash.conf /etc/logstash/conf.d/logstash.conf
ADD suricata.json /var/www/html/app/dashboards/default.json
ADD small.png /var/www/html/img/small.png

# Clean up 
RUN apt-get remove wget -y && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Start ELK
CMD ["/usr/bin/supervisord"]
