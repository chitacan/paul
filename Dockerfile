# build
FROM bitwalker/alpine-elixir:1.7.3 as build
COPY . .
RUN export MIX_ENV=prod && \
    mix deps.get && \
    mix release
RUN mkdir /export
RUN cp _build/prod/rel/paul/releases/*/paul.tar.gz /export

FROM bitwalker/alpine-erlang:latest
EXPOSE 4000
ENV PORT=4000
ENV MIX_ENV=prod
COPY --from=build /export/ .
RUN tar -xf paul.tar.gz && rm paul.tar.gz
# disable epmd (https://github.com/zeit/now-examples/blob/master/elixir-phoenix/Dockerfile#L18)
RUN sed -i -e 's/_configure_node$/# _configure_node/' releases/0.0.1/libexec/config.sh
USER default
ENTRYPOINT ["./bin/paul"]
CMD ["foreground"]
