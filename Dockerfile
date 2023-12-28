FROM golang:1.21

WORKDIR /usr/src/app
RUN git clone --single-branch -b develop https://github.com/pacenotesio/simpleserver.git .

# pre-copy/cache go.mod for pre-downloading dependencies and only redownloading them in subsequent builds if they change
COPY go.mod go.sum ./
RUN go mod download && go mod verify

#COPY . .
RUN go build -v -o /usr/local/bin/app ./server.go

CMD ["app"]