FROM docker.io/library/golang:1.14.4 as builder
LABEL maintainer="maintainer@cilium.io"
ADD . /go/src/github.com/cilium/stale-rules
WORKDIR /go/src/github.com/cilium/stale-rules
RUN CGO_ENABLED=0 GOOS=linux go build -o stale-rules

FROM scratch
LABEL maintainer="maintainer@cilium.io"
COPY --from=builder /go/src/github.com/cilium/stale-rules/stale-rules /usr/bin/stale-rules
WORKDIR /
CMD ["/usr/bin/stale-rules"]
