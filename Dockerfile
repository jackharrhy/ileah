ARG ELIXIR_VERSION=1.18.4
ARG OTP_VERSION=28.0.2
ARG DEBIAN_VERSION=bookworm-20250721-slim

ARG BUILDER_IMAGE="hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-debian-${DEBIAN_VERSION}"

RUN apk add --no-cache git

WORKDIR /app

COPY mix.exs mix.lock ./

ENV MIX_ENV=prod

RUN mix do deps.get, deps.compile

COPY lib ./lib
COPY config ./config

RUN mix do compile
RUN mix release

FROM hexpm/erlang:27.2-alpine-3.20.3

WORKDIR /app

COPY --from=builder /app/_build/prod/rel/ileah ./

CMD ["./bin/ileah", "start"]
