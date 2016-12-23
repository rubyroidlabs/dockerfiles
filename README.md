# README

#### Ruby version
-   2.3.3


#### System dependencies
-   docker


#### Instructions

##### install docker at remote machine:
```
docker-machine create --driver generic \
   --generic-ip-address REMOTE_HOST_IP \
   --generic-ssh-user REMOTE_HOST_USER \
   --generic-ssh-key KEY_PATH \
   --engine-storage-driver devicemapper \
   MACHINE_NAME
```

##### attach your docker client to remote machine:
```
eval $(docker-machine env MACHINE_NAME)
```

###### build base-images (only first time):

```
docker build -t rails-base ./docker/rails-base/
docker build -t node-base ./docker/angular2-base/
```

##### build all containers:

*   prod:

    ```
    docker-compose \
      --project-name PROJECT \
      -f docker-compose.yml \
      -f docker-compose.prod.yml \
      build --no-cache
    ```

*   stage:

    ```
    docker-compose \
      --project-name PROJECT \
      -f docker-compose.yml \
      -f docker-compose.stage.yml \
      build --no-cache
    ```

##### start all containers:

*   prod:

    ```
    docker-compose \
      --project-name PROJECT \
      -f docker-compose.yml \
      -f docker-compose.prod.yml \
      up -d
    ```

*   stage:

    ```
    docker-compose \
      --project-name PROJECT \
      -f docker-compose.yml \
      -f docker-compose.stage.yml \
      up -d
    ```


###### * To build only one container, for example `frontend` in `prod`, run:

```
docker-compose \
  --project-name PROJECT \
  -f docker-compose.yml \
  -f docker-compose.prod.yml \
  build --no-cache \
  frontend
```


###### ** To start it attached to console, run:

```
docker-compose \
  --project-name PROJECT \
  -f docker-compose.yml \
  -f docker-compose.prod.yml \
  up \
  frontend
```


###### *** To attach to the existing container, run:

```
docker-compose \
  --project-name PROJECT \
  -f docker-compose.yml \
  -f docker-compose.prod.yml \
  exec \
  frontend /bin/bash
```
