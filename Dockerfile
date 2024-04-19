FROM registry.cn-hangzhou.aliyuncs.com/eryajf/golang:1.22.2-alpine3.19 AS builder

WORKDIR /app
ENV GOPROXY      https://goproxy.io

RUN sed -i "s/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g" /etc/apk/repositories \
    && apk upgrade && apk add --no-cache --virtual .build-deps \
    ca-certificates gcc g++ curl upx

ADD . .

RUN go build -o lor . && upx -9  lor

FROM registry.cn-hangzhou.aliyuncs.com/eryajf/alpine:3.19

WORKDIR /app

COPY --from=builder /app/lor .

RUN chmod +x lor