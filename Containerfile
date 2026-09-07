# syntax=docker/dockerfile:1
# The RFD site and MCP endpoint as one Elixir release. Stage 1 compiles the
# release and packs the corpus (rfd/*.exs, SERIALS*.exs, logbook, agreements)
# into priv/corpus.bin; stage 2 is a slim runtime that never sees the sources.

ARG ELIXIR_IMAGE=docker.io/hexpm/elixir:1.20.4-erlang-29.0.6-debian-bookworm-20260824-slim
ARG RUNTIME_IMAGE=docker.io/debian:bookworm-slim

FROM ${ELIXIR_IMAGE} AS build

RUN apt-get update -y \
  && apt-get install -y --no-install-recommends git ca-certificates curl \
  && rm -rf /var/lib/apt/lists/*

ENV MIX_ENV=prod

RUN mix archive.install github hexpm/hex branch latest --force
RUN curl -fsSL -o /usr/local/bin/rebar3 https://github.com/erlang/rebar3/releases/latest/download/rebar3 \
  && chmod +x /usr/local/bin/rebar3 \
  && mix local.rebar rebar3 /usr/local/bin/rebar3 --force

WORKDIR /app
COPY mix.exs mix.lock ./
RUN mix deps.get --only prod
RUN mix deps.compile

COPY config config
COPY lib lib
RUN mix compile

COPY rfd rfd
COPY SERIALS.exs SERIALS-vsekai-fabric.exs ./
COPY logbook logbook
COPY CLAUDE.md BLOCKLIST.md PITFALLS.md KEYPOINTS.md ./
RUN mix rfd.pack
RUN mix release rfd_site

FROM ${RUNTIME_IMAGE} AS app

RUN apt-get update -y \
  && apt-get install -y --no-install-recommends libstdc++6 openssl libncurses6 ca-certificates \
  && rm -rf /var/lib/apt/lists/*

ENV MIX_ENV=prod \
    PORT=8080 \
    LANG=C.UTF-8

WORKDIR /app
COPY --from=build /app/_build/prod/rel/rfd_site ./

RUN useradd --create-home app && chown -R app:app /app
USER app

EXPOSE 8080
CMD ["/app/bin/rfd_site", "start"]
