FROM elixir:1.6.6-otp-21 as build
RUN apt-get update
RUN apt-get install -y inotify-tools

WORKDIR /app
COPY . /app
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get

RUN mix compile.phoenix

RUN apt-get update && apt-get install -y ngspice

FROM elixir:1.6.6-otp-21-alpine as final
RUN apk update && apk add inotify-tools

WORKDIR /app
COPY --from=build /app .
COPY --from=build /usr/bin/ngspice /usr/bin/ngspice

ENV PATH="${PATH}:/app"

EXPOSE 8080

CMD ["mix", "phx.server"]
