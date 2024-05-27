FROM alpine

RUN apk add --no-cache git

COPY sync.sh /sync.sh
ENTRYPOINT ["/bin/sh","/sync.sh"]