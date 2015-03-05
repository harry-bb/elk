# dockerized elk stack


[elk](http://www.elasticsearch.org/overview/) is a stack combining elasticsearch, logstash and the kibana dashboard and enables to structure and vizualize data in realtime. 

This repository contains the necessary files to create a *dockerized* version of the elk stack. 

This dockerized version is part of the **[T-Pot community honeypot](http://dtag-dev-sec.github.io/)** of Deutsche Telekom AG. 

The `Dockerfile` contains the blueprint for the dockerized elk stack and will be used to setup the docker image.  

The `000-default.conf` is a reverse proxy directive for apache in order to be able to reach the kibana dashboard on T-Pot. 

Further, `elasticsearch.yml`, `logstash.conf`and `suricata.json` are all tailored to fit the T-Pot environment. All important data is stored in `/data/elk/`.

The `supervisord.conf` is used to start the elk stack under supervision of supervisord. 

Using upstart, copy the `upstart/elk.conf` to `/etc/init/elk.conf` and start using

    service start elk

This will make sure that the docker container is started with the appropriate rights and port mappings. Further, it autostarts during boot.

To access the kibana dashboard, make sure you have enabled SSH on T-Pot (see T-Pot documentation), then enable the [port forward](http://explainshell.com/explain?cmd=ssh+-p+64295+-l+tsec+-N+-L8080%3A127.0.0.1%3A64296+yourHoneypotsPublicIPaddress)  and make sure you leave the terminal open.

    ssh -p 64295 -l tsec -N -L8080:127.0.0.1:64296 <yourHoneypotsPublicIPaddress>

Finally, open a webbrowser and access http://127.0.0.1:8080. The kibana dashboard can be customized to fit your needs.
