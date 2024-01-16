FROM golang:1.21 as builder

#WORKDIR /usr/src/openapi
#RUN git clone --single-branch -b main https://github.com/pacenotesio/openapi.git .

WORKDIR /usr/src/simpleapi
RUN git clone --single-branch -b main https://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:x-oauth-basic@github.com/pacenotesio/simpleapi.git .
RUN go install github.com/pressly/goose/v3/cmd/goose@v3.16.0
RUN go get github.com/joho/godotenv
RUN go build -v -o /usr/local/bin/simpleapi ./main.go

WORKDIR /usr/src/app
RUN git clone --single-branch -b main https://github.com/pacenotesio/simpleserver.git .

# pre-copy/cache go.mod for pre-downloading dependencies and only redownloading them in subsequent builds if they change
#COPY go.mod go.sum ./
#RUN go mod download && go mod verify

#COPY . .
RUN go build -v -o /usr/local/bin/app ./server.go

#COPY ./html /usr/local/apache2/htdocs/

FROM golang:1.21

WORKDIR /usr/src/simpleapi
RUN git clone --single-branch -b main https://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:x-oauth-basic@github.com/pacenotesio/simpleapi.git .
#RUN go install github.com/pressly/goose/v3/cmd/goose@v3.16.0
#RUN go get github.com/joho/godotenv

COPY --from=builder /usr/local/bin/app /usr/local/bin
COPY --from=builder /usr/local/bin/simpleapi /usr/local/bin
COPY --from=builder /usr/src/simpleapi/.env /usr/local/bin
COPY --from=builder /usr/src/simpleapi/app.config.yaml /usr/local/bin

CMD ["app"]