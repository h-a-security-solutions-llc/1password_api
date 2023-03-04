FROM golang:latest

MAINTAINER Justin Henderson justin@hasecuritysolutions.com

RUN apt update \
  && wget https://github.com/1Password/events-api-elastic/archive/refs/tags/v2.4.0.tar.gz \
  && tar xzvf v2.4.0.tar.gz \
  && cd events-api-elastic-2.4.0 \
  && make eventsapibeat \
  && mkdir /opt/eventsapibeat/data -p \
  && cp /go/events-api-elastic-2.4.0/bin/* /opt/eventsapibeat \
  && mkdir -p /etc/beats \
  && cp /go/events-api-elastic-2.4.0/eventsapibeat-sample.yml /etc/beats/eventsapibeat.yml \
  && cd /go \
  && rm -rf /go/events-api-elastic-2.4.0 \
  && apt clean \
  && useradd -ms /bin/bash eventsapibeat \
  && chown -R eventsapibeat:eventsapibeat /opt/eventsapibeat \
  && chmod 500 /opt/eventsapibeat/*

USER eventsapibeat
WORKDIR /opt/eventsapibeat

STOPSIGNAL SIGTERM

CMD /opt/eventsapibeat/eventsapibeat -c /etc/beats/eventsapibeat.yml --path.data /opt/eventsapibeat/data -e
