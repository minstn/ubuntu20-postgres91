# Docker Postgres 9.1 on ubuntu:20.04 image

Docker image based on `Ubuntu:20.04` version.
Good for legacy apps based on php5.6/php5.6-fpm like `CakePhp` etc.
If you have an idea how to improve it, contact me <minstn@gmail.com>.

## Includes `Postgres 9.1` database

Download the PostgreSQL repository configuration file: 
```
wget -O /etc/apt/sources.list.d/pgdg.list http://apt.postgresql.org/pub/repos/apt/pool/main/pgdg.list
```

Import the PostgreSQL GPG key: 
```
apt-key add --keyserver hkp://keyserver.ubuntu.com:80/ --key 4041C04B 
```

```
apt-get update
apt install postgresql-9.1 
systemctl start postgresql-9.1
systemctl enable postgresql-9.1 
systemctl status postgresql-9.1
sudo -u postgres psql
```

## Includes packages

 * Postgres 9.1


## Usage

Build your image.

```sh
docker build -t ubuntu20-postgres91:v1 --progress=plain  .
```

Bind local port 8081 to the container.

```sh
docker run -p 5432:5432 --volume   - ./data:/var/lib/postgresql/data ubuntu20-postgres91:v1
```

```sh
docker ps -a
docker exec -it <image_id>  bash
```

Tag and publish the image to dockers image repo as `stable`

```sh
docker tag <image_id> minstn/ubuntu20-postgres91:stable
docker push minstn/ubuntu20-postgres91
```

Creating container via `docker-compose` file.

```yaml
  web:
    image: ubuntu20-postgres91
    container_name: postgres91
    restart: always
    volumes:
      # 1. mount your workdir path
      - ./data:/var/lib/postgresql/data 
    command:
      # remember to escape variables dollar sign with duplication $$ instead $
      # - '* * * * * echo "Hello $$(date)" >> /var/log/cron.log 2>&1'
      # - '* * * * * echo "Hello world !" >> /var/log/cron.log 2>&1'
```


