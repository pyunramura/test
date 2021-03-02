FROM alpine:3.9
LABEL name="test2" \
      maintainer="Test Users <testuser@testsite.org>" \
      version="1.0.0"
COPY run.sh /
RUN "apk update && apk add --no-cache lighttpd && \
  chmod 755 /run.sh && \
  mkdir -p /var/www/localhost/htdocs /var/log/lighttpd /var/lib/lighttpd && \
  sed -i -r 's#\#.*server.port.*=.*#server.port          = 80#g' /etc/lighttpd/lighttpd.conf && \
  sed -i -r 's#\#.*server.event-handler = "linux-sysepoll".*#server.event-handler = "linux-sysepoll"#g' /etc/lighttpd/lighttpd.conf && \
  chown -R lighttpd:lighttpd /var/www/localhost/ /var/lib/lighttpd /var/log/lighttpd && \
  rc-update add lighttpd default && rc-service lighttpd restart && echo -e "Hello World!\nPlease moune a new index.html to /var/www/localhost/htdocs" > /var/www/localhost/htdocs/index.html
USER lighttpd
EXPOSE 80
HEALTHCHECK --interval=1m --timeout=1s \
  CMD curl -f http://localhost/ || exit 1
VOLUME /var/www/localhost/htdocs
ENTRYPOINT ["/usr/sbin/lighttpd", "-D"]
CMD [/run.sh]