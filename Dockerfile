FROM alpine:3.18
WORKDIR /usr/src
RUN apk add --no-cache git openssh-client
COPY entrypoint.sh .
ENTRYPOINT ["/usr/src/entrypoint.sh"]
