# Paul

폴 바셋 카드 잔액 확인하기.

## prerequites

* docker
* elixir
* now

## development

```
$ mix deps.get,deps.compile
$ mix phx.server
```

## build with docker

```
$ docker build -t <IMAGE_NAME> .
$ docker run --rm -it <IMAGE_NAME>
```

## deploy with now

```
$ now
```

> `paul-bassett-id`, `paul-bassett-pw` should be added on your `now secret`
