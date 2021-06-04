FROM golang:1.16-alpine AS builder

WORKDIR /usr/src/test

COPY ./go.mod /usr/src/test/

COPY ./go.sum /usr/src/test/

ENV GOPROXY=https://goproxy.cn,direct CGO_ENABLED=0

RUN go mod download

#RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
#  apk add --no-cache ca-certificates tzdata

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories && \
  apk add --no-cache ca-certificates tzdata

COPY . /usr/src/test/

RUN go build -tags netgo -ldflags "-s -w" -o test

FROM alpine as runner

COPY --from=builder /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

COPY --from=builder /usr/src/test /opt/app/

CMD ["/opt/app/test"]
