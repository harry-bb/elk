# dockerized elk stack


[elk](http://www.elasticsearch.org/overview/) is a stack combining elasticsearch, logstash and the kibana dashboard. It is used to structure and vizualize data in realtime.

This repository contains the necessary files to create a *dockerized* version of the elk stack.

This dockerized version is part of the **[T-Pot community honeypot](http://dtag-dev-sec.github.io/)** of Deutsche Telekom AG.

The `Dockerfile` contains the blueprint for the dockerized elk stack and will be used to setup the docker image.  

Further, `elasticsearch.yml`, `logstash.conf`, `elkbase.tar.gz`, `elk.ico` and `kibana.svg`,  are all tailored to fit the T-Pot environment.

The `supervisord.conf` is used to start the elk stack under supervision of supervisord.

Using upstart, copy the `upstart/elk.conf` to `/etc/init/elk.conf` and start using

    service elk start

This will make sure that the docker container is started with the appropriate rights and port mappings. Further, it autostarts during boot.

To access the kibana dashboard, make sure you have enabled SSH on T-Pot (see T-Pot documentation), then enable the [port forwarding](http://explainshell.com/explain?cmd=ssh+-p+64295+-l+tsec+-N+-L8080%3A127.0.0.1%3A64296+yourHoneypotIPaddress)  and make sure you leave the terminal open.

    ssh -p 64295 -l tsec -N -L8080:127.0.0.1:64296 <yourHoneypotIPaddress>

Finally, open a webbrowser and go to http://127.0.0.1:8080/app/kibana#/dashboard/Default.

Note: The kibana dashboard can be customized to fit your needs.

By default all data will be persistently stored in `/data/elk/`. By default indexed events older than 90 days will be deleted. You can adjust this in `/etc/crontab` to fit your needs, but be advised to provide enough RAM and free disk-space if you wish to do so.

# T-Pot Dashboard

![T-Pot Dashboard](https://raw.githubusercontent.com/dtag-dev-sec/elk/master/doc/dashboard.png)
