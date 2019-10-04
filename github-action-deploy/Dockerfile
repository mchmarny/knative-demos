FROM golang:latest as builder

WORKDIR /src/
COPY . /src/

ENV GO111MODULE=on
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -a -tags netgo \
    -ldflags '-s -w -extldflags "-static"' \
    -mod vendor \
    -o service

FROM gcr.io/distroless/static:nonroot
COPY --from=builder /src/service .
ENTRYPOINT ["./service"]