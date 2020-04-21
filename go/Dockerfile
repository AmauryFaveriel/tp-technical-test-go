FROM golang:1.13-alpine

RUN mkdir /app

WORKDIR /app

COPY . .

RUN go build main.go

CMD ["/app/main"]