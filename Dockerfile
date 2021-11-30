FROM alpine:3

RUN apk add --no-cache bash git jq

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
