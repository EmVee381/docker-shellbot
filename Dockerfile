FROM rust:alpine AS builder
RUN apk --update add --no-cache curl git musl-dev
WORKDIR /
RUN git clone https://github.com/blinry/habitctl
WORKDIR /habitctl
RUN cargo build --release


FROM node:alpine
RUN apk add socat curl tzdata findutils git python3 gcc musl-dev make g++ curl vim fish docker zsh tmux
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_CTYPE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8
RUN ln -fs /usr/share/zoneinfo/Europe/Prague /etc/localtime
WORKDIR /app
RUN npm install -g pm2
RUN chown 1000:1000 /app

USER node
RUN git clone https://github.com/EmVee381/shell-bot.git
WORKDIR /app/shell-bot
RUN npm install
COPY --from=builder /habitctl/target/release/habitctl /usr/sbin/
COPY start.sh /
CMD /start.sh
