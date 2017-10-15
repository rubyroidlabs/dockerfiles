# README

## Ruby version
-   2.3.3


## System dependencies
-   docker


## Dev instructions

### start in development:
```
docker-compose up
```

if there is no images and command fails:

```
docker-compose build
```

and then `docker-compose up`

By default docker reads `docker-compose.yml` and `docker-compose.override.yml`

`docker-compose.override.yml` contains overrides for development.
`docker-compose.staging.yml` - for staging.
`docker-compose.production.yml` - for production.

#### To use rails console:
```
docker-compose exec backend rails c
```

#### To use pry:
```
docker-compose stop backend && docker-compose run --service-ports backend
```


## Deploy instructions

### install docker at remote machine:
```
docker-machine create --driver generic \
   --generic-ip-address REMOTE_HOST_IP \
   --generic-ssh-user REMOTE_HOST_USER \
   --generic-ssh-key KEY_PATH \
   --engine-storage-driver devicemapper \
   MACHINE_NAME
```

### attach your docker client to remote machine:
```
eval $(docker-machine env MACHINE_NAME)
```

### build all containers:

*   production:

    ```
    docker-compose \
      --project-name PROJECT \
      -f docker-compose.yml \
      -f docker-compose.production.yml \
      build --no-cache
    ```

*   staging:

    ```
    docker-compose \
      --project-name PROJECT \
      -f docker-compose.yml \
      -f docker-compose.staging.yml \
      build --no-cache
    ```

### start all containers:

*   production:

    ```
    docker-compose \
      --project-name PROJECT \
      -f docker-compose.yml \
      -f docker-compose.production.yml \
      up -d
    ```

*   staging:

    ```
    docker-compose \
      --project-name PROJECT \
      -f docker-compose.yml \
      -f docker-compose.staging.yml \
      up -d
    ```


#### * To build only one container, for example `frontend` in `production`, run:

```
docker-compose \
  --project-name PROJECT \
  -f docker-compose.yml \
  -f docker-compose.production.yml \
  build --no-cache \
  frontend
```


#### ** To start it attached to console, run:

```
docker-compose \
  --project-name PROJECT \
  -f docker-compose.yml \
  -f docker-compose.production.yml \
  up \
  frontend
```


#### *** To attach to the existing container, run:

```
docker-compose \
  --project-name PROJECT \
  -f docker-compose.yml \
  -f docker-compose.production.yml \
  exec \
  frontend /bin/bash
```

#### *** To view logs

```
docker-compose \
  --project-name PROJECT \
  -f docker-compose.yml \
  -f docker-compose.production.yml \
  logs -f
```
