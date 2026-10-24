ARG GO_VERSION=1.27
FROM golang:${GO_VERSION}-alpine AS build

ARG OCB_VERSION=0.163.0
RUN go install go.opentelemetry.io/collector/cmd/builder@v${OCB_VERSION}

WORKDIR /src
COPY builder-config.yaml .
RUN CGO_ENABLED=0 builder --config=builder-config.yaml

FROM gcr.io/distroless/static-debian12:nonroot
COPY --from=build /src/_build/otelcol-gateway /otelcol-gateway
ENTRYPOINT ["/otelcol-gateway"]
CMD ["--config=/etc/otelcol/config.yaml"]
