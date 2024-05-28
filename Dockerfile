FROM alpine

RUN apk add --no-cache git bash

COPY sync.sh /sync.sh
ENTRYPOINT ["/bin/bash","/sync.sh"]