FROM alpine:3.13

COPY run /

RUN \
  apk add --no-cache \
    lighttpd=1.4.56-r0

RUN chmod 755 /run

RUN mkdir -p /var/www/localhost/htdocs /var/log/lighttpd /var/lib/lighttpd

RUN sed -i -r 's#\#.*server.port.*=.*#server.port         = 80#g' /etc/lighttpd/lighttpd.conf

RUN sed -i -r 's#\#.*server.event-handler = "linux-sysepoll".*#server.event-handler = "linux-sysepoll"#g' /etc/lighttpd/lighttpd.conf

RUN chown -R lighttpd:lighttpd /var/www/localhost/ /var/lib/lighttpd /var/log/lighttpd

USER lighttpd

EXPOSE 80

HEALTHCHECK --interval=1m --timeout=1s \
  CMD curl -f http://localhost || exit 1

VOLUME /var/www/localhost/htdocs

ENTRYPOINT ["/usr/sbin/lighttpd", "-D"]

CMD [/run]