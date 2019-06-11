ARG BASE_IMAGE=golang:alpine

FROM ${BASE_IMAGE} AS builder

ENV GO111MODULE=on

RUN apk update --no-cache && \
    apk add git

WORKDIR /app

ADD ./ /app

RUN go build -o golang-test  .

FROM alpine:3.6.5

WORKDIR /app

# Copy from builder as part of multi-stage building
COPY --from=builder /app/golang-test .

ENTRYPOINT ["/app/golang-test"]

EXPOSE 8000