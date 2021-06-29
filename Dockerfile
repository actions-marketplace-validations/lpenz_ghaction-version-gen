# Copyright (C) 2021 Leandro Lisboa Penz <lpenz@lpenz.org>
# This file is subject to the terms and conditions defined in
# file 'LICENSE', which is part of this source code package.

FROM rust:1.53-alpine AS build
WORKDIR /src
COPY Cargo.* ./
COPY src ./src
RUN set -e -x; \
    apk update; \
    apk add --no-cache musl-dev; \
    cargo build --release

FROM alpine:3.14
RUN set -e -x; \
    apk update; \
    apk add --no-cache git; \
    rm -rf /var/cache/apk/*
COPY --from=build /src/target/release/githeadinfo /usr/local/bin/
CMD ["/usr/local/bin/githeadinfo"]