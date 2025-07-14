FROM alpine:latest

RUN apk add --update --no-cache \
    curl privoxy i2pd tor \
    ca-certificates && \
    rm /etc/privoxy/*.new

#COPY --chown=privoxy:privoxy ./privoxy/privoxy.conf /etc/privoxy/config
#COPY --chown=privoxy:privoxy ./privoxy/action.conf /etc/privoxy/default.action
#COPY --chown=privoxy:privoxy ./privoxy/filters.conf /etc/privoxy/default.filter
#COPY --chown=i2pd:i2pd ./i2pd.conf /etc/i2pd/i2pd.conf
#COPY --chown=tor:tor ./torrc.conf /etc/tor/torrc
COPY --chmod=755 ./entrypoint.sh /entrypoint.sh

COPY /etc/ /etc/

# Remove sample config files
#RUN rm /etc/privoxy/*.new

EXPOSE 8118/tcp 9050/tcp 4444/tcp

HEALTHCHECK --interval=5m --timeout=5s \
  CMD timeout 2 curl -sfo /dev/null --proxy 127.0.0.1:8118 -L 'http://config.privoxy.org/'

ENTRYPOINT [ "/bin/sh", "/entrypoint.sh" ]
