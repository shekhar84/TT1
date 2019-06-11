ARG BASE_IMAGE=golang:alpine

FROM ${BASE_IMAGE} AS builder

ENV GO111MODULE=on

RUN apk update --no-cache && \
    apk add git

WORKDIR /app

ADD ./ /app


RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags '-w -extldflags "-static"' -o golang-test

FROM scratch

WORKDIR /app

# Copy from builder as part of multi-stage building
COPY --from=builder /app/golang-test /app

ENTRYPOINT ["/app/golang-test"]

EXPOSE 8000
