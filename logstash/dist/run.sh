#!/bin/bash
cd /etc/listbot && git pull
cd /
/usr/share/logstash/bin/logstash -f /etc/logstash/conf.d/logstash.conf
