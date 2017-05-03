# Elasticsearch-head Dockerfile by MO
#
# VERSION 17.06 
FROM node:alpine
MAINTAINER MO

# Setup env and apt
RUN apk -U add bash curl nodejs git && \

# Get and install packages
    mkdir -p /usr/src/app/ && \
    cd /usr/src/app/ && \
    git clone https://github.com/mobz/elasticsearch-head . && \
    npm install http-server && \
    sed -i 's/\"http\:\/\/localhost\:9200\"/\"https\:\/\/\<FQDN\>\:64297\/es\/\"/' /usr/src/app/_site/app.js && \

# Clean up
    apk del git

# Healthcheck
HEALTHCHECK --timeout=5s CMD curl -s -XGET 'http://127.0.0.1:9100'

# Start elasticsearch-head
WORKDIR /usr/src/app
CMD ["node_modules/http-server/bin/http-server", "_site", "-p", "9100"]
