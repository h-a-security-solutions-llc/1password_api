FROM golang:latest as build

MAINTAINER Justin Henderson justin@hasecuritysolutions.com

RUN apt update \
  && wget https://github.com/1Password/events-api-elastic/archive/refs/tags/v2.4.0.tar.gz \
  && tar xzvf v2.4.0.tar.gz \
  && cd events-api-elastic-2.4.0 \
  && make eventsapibeat

FROM gcr.io/distroless/static-debian11

COPY --from=build /go/events-api-elastic-2.4.0/bin/* /opt/eventsapibeat/
COPY --from=build /go/events-api-elastic-2.4.0/eventsapibeat-sample.yml /etc/beats/eventsapibeat.yml


RUN mkdir /opt/eventsapibeat/data -p \
  && mkdir -p /etc/beats \
  && useradd -ms /bin/bash eventsapibeat \
  && chown -R eventsapibeat:eventsapibeat /opt/eventsapibeat \
  && chmod 500 /opt/eventsapibeat/*

USER eventsapibeat
WORKDIR /opt/eventsapibeat

STOPSIGNAL SIGTERM

CMD /opt/eventsapibeat/eventsapibeat -c /etc/beats/eventsapibeat.yml --path.data /opt/eventsapibeat/data -e
