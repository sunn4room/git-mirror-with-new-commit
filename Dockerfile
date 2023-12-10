FROM alpine:3.18
WORKDIR /usr/src
COPY entrypoint.sh .
ENTRYPOINT ["/usr/src/entrypoint.sh"]
