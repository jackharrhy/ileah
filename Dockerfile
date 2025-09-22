ARG ELIXIR_VERSION=1.18.4
ARG OTP_VERSION=28.0.2
ARG OS_VERSION=alpine-3.22.1

ARG BUILDER_IMAGE="hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-${OS_VERSION}"
ARG RUNTIME_IMAGE="hexpm/erlang:${OTP_VERSION}-${OS_VERSION}"

FROM ${BUILDER_IMAGE} AS builder

RUN apk add --no-cache git

WORKDIR /app

COPY mix.exs mix.lock ./

ENV MIX_ENV=prod

RUN mix do deps.get, deps.compile

COPY lib ./lib
COPY config ./config

RUN mix do compile
RUN mix release

FROM ${RUNTIME_IMAGE}

WORKDIR /app

COPY --from=builder /app/_build/prod/rel/ileah ./

CMD ["./bin/ileah", "start"]
