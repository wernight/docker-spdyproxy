FROM node:6-slim

RUN set -x \
 && npm install -g spdyproxy \
 && useradd --system --uid 1593 --shell /usr/sbin/nologin -M spdy \
 && mkdir /ssl \
 && chown -R spdy:spdy /ssl

VOLUME /ssl

EXPOSE 44300

COPY *.sh /

USER spdy

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/start_spdyproxy.sh"]
