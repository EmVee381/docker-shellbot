FROM rust:alpine AS builder
RUN apk --update add --no-cache curl git musl-dev
WORKDIR /
RUN git clone https://github.com/blinry/habitctl
WORKDIR /habitctl
RUN cargo build --release


FROM node:alpine
RUN apk add git python3 gcc musl-dev make g++ curl vim fish docker zsh tmux
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
RUN git clone https://github.com/EmVee381/shell-bot.git
WORKDIR /shell-bot
RUN npm install
RUN npm install -g supervisor
COPY --from=builder /habitctl/target/release/habitctl /usr/sbin/
COPY config.json /shell-bot/
COPY start.sh /
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_CTYPE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8
RUN apk add --update --no-cache socat curl tzdata findutils
RUN ln -fs /usr/share/zoneinfo/Europe/Prague /etc/localtime

CMD /start.sh
