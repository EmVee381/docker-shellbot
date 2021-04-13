FROM rust:alpine AS builder
RUN apk --update add --no-cache curl git musl-dev
WORKDIR /
RUN git clone https://github.com/NerdyPepper/dijo
RUN git clone https://github.com/blinry/habitctl
WORKDIR /habitctl
RUN cargo build --release
WORKDIR /dijo
RUN cargo build --release



FROM node:alpine
RUN sed -i -e 's/v[[:digit:]]\..*\//edge\//g' /etc/apk/repositories
RUN sed -i -e 's~:/bin/sh$~:/usr/bin/fish~' /etc/passwd
RUN apk update && apk add socat curl tzdata findutils git python3 gcc musl-dev make g++ curl vim fish docker bash tmux openssh-client the_silver_searcher ripgrep ncurses jq go
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_CTYPE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8
RUN ln -fs /usr/share/zoneinfo/Europe/Prague /etc/localtime
WORKDIR /app
RUN npm install -g npm
RUN npm install -g pm2
RUN chown 1000:1000 /app
RUN git clone https://github.com/wakatara/harsh
WORKDIR /app/harsh
RUN go get ./...
RUN go build -o harsh .
RUN cp harsh /usr/sbin
USER node
WORKDIR /app
RUN git clone https://github.com/EmVee381/shell-bot.git
WORKDIR /app/shell-bot
RUN npm install
COPY --from=builder /habitctl/target/release/habitctl /usr/sbin/
COPY --from=builder /dijo/target/release/dijo /usr/sbin/
COPY start.sh /
CMD /start.sh

