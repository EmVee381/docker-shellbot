FROM rust:alpine AS builder
RUN apk --update add --no-cache curl git musl-dev
WORKDIR /
RUN git clone https://github.com/blinry/habitctl
WORKDIR /habitctl
RUN cargo build --release


FROM node:alpine
RUN apk add git python3 gcc musl-dev make g++ curl vim fish docker
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
RUN git clone https://github.com/EmVee381/shell-bot.git
WORKDIR /shell-bot
RUN npm install
RUN npm install -g supervisor
COPY --from=builder /habitctl/target/release/habitctl /usr/sbin/
COPY config.json /shell-bot/
COPY start.sh /
RUN apk add zsh screen
CMD /start.sh
