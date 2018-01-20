# loom

loom es una aplicación web que acompaña a los estudiantes en su cursada

## Setup

```shell
  cp .env.example .env
  nano .env

  docker-compose run app rake db:setup db:seed
```

## Running the app

```shell
  docker-compose up
```

## Stopping the app

```shell
  docker-compose down
```

## Contribuciones

1. Hacer un fork
2. Crear un feature-branch (`git checkout -b my-new-feature`)
3. Commitear los cambios (`git commit -am 'Add some feature'`)
4. Hacer push al branch (`git push origin my-new-feature`)
5. Crear un Pull Request
