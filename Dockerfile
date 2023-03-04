FROM golang:latest as build

MAINTAINER Justin Henderson justin@hasecuritysolutions.com

RUN wget https://github.com/1Password/events-api-elastic/archive/refs/tags/v2.4.0.tar.gz \
  && tar xzvf v2.4.0.tar.gz \
  && cd events-api-elastic-2.4.0 \
  && make eventsapibeat \
  && mkdir /go/events-api-elastic-2.4.0/bin/data -p \
  && mkdir /opt/eventsapibeat -p \
  && useradd -ms /bin/bash eventsapibeat \
  && chown -R 1000:1000 /opt/eventsapibeat \
  && chmod -R 500 /opt/eventsapibeat

FROM gcr.io/distroless/static-debian11

COPY --from=build /go/events-api-elastic-2.4.0/bin /opt/eventsapibeat
COPY --from=build /go/events-api-elastic-2.4.0/eventsapibeat-sample.yml /etc/beats/eventsapibeat.yml

USER eventsapibeat
WORKDIR /opt/eventsapibeat

STOPSIGNAL SIGTERM

CMD /opt/eventsapibeat/eventsapibeat -c /etc/beats/eventsapibeat.yml --path.data /opt/eventsapibeat/data -e
