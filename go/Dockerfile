FROM golang:1.13-alpine as build

WORKDIR /home/app

COPY . .

ARG REDIS_HOST

RUN go build -o webapp main.go

FROM alpine:3.11.5

WORKDIR /home/app

COPY public ./public

COPY --from=build /home/app/webapp ./webapp

CMD ["/home/app/webapp"]

EXPOSE 8080
