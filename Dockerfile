FROM ubuntu:latest

MAINTAINER Justin Henderson justin@hasecuritysolutions.com

RUN apt update \
  && apt install wget -y \
  && wget https://github.com/1Password/events-api-elastic/releases/download/v2.4.0/eventsapibeat_2.4.0_linux_amd64.tar.gz \
  && tar xzvf eventsapibeat_2.4.0_linux_amd64.tar.gz \
  && cd linux_amd64 \
  && mkdir /opt/eventsapibeat -p \
  && mkdir /etc/beats -p \
  && cp eventsapibeat /opt/eventsapibeat \
  && cp eventsapibeat-sample.yml /etc/beats/eventsapibeat.yml \
  && useradd -ms /bin/bash eventsapibeat \
  && chown -R 1000:1000 /opt/eventsapibeat \
  && chmod -R 500 /opt/eventsapibeat

USER eventsapibeat
WORKDIR /opt/eventsapibeat

STOPSIGNAL SIGTERM

CMD /opt/eventsapibeat/eventsapibeat -c /etc/beats/eventsapibeat.yml --path.data /opt/eventsapibeat/data -e
