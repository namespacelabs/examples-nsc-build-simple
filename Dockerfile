# syntax=docker/dockerfile:1

## Build step
FROM golang:1.20-alpine AS build

WORKDIR /app

ENV CGO_ENABLED 0

COPY go.* ./
COPY *.go ./

RUN go build -o /goapp


## Deploy step
FROM gcr.io/distroless/base-debian10 as prod

WORKDIR /

COPY --from=build /goapp /goapp

USER nonroot:nonroot

ENTRYPOINT ["/goapp"]