FROM golang:latest AS builder

RUN go env -w GO111MODULE=auto
WORKDIR /go/src/codeeducation/hello/
COPY . .
RUN GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o app .

FROM gruebel/upx:latest as upx
COPY --from=builder /go/src/codeeducation/hello/app /app.org
RUN upx --best --lzma -o /app /app.org

FROM scratch
COPY --from=upx /app .
ENTRYPOINT ["./app"]