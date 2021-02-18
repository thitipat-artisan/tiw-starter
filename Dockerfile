FROM golang:alpine AS builder
ENV GO111MODULE=on CGO_ENABLED=0 GOOS=linux GOARCH=amd64
WORKDIR /app
COPY . ./
RUN go mod download && go build -o server .

FROM alpine:latest
RUN apk add --no-cache ca-certificates && update-ca-certificates
WORKDIR /app
COPY .env.dev ./.env
COPY --from=builder /app/server ./
ENV PORT=8080
EXPOSE 8080
CMD ["/app/server"]
