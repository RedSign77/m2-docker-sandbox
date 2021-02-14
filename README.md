# Docker environment for Sandbox M2 project (Linux only)

## First steps
### Install _Docker_ and _Docker Compose_
For more information visit the [official Docker documentation](https://docs.docker.com/get-docker/).
### Clone this repository
```
git clone https://github.com/RedSign77/m2-docker-sandbox sandboxm2
```
> Note: make sure you can clone repositories from GitLab over SSH
### Stop all services using port 80 and 443
e.g. Apache/Nginx server or another docker containers running on the host machine.

## Setup
### Option A) Build images, run containers and setup Magento using script (recommended)
Run the
```
make install
```
command from project root.

### Option B) Build images, run containers and setup Magento manually
Run the commands found in the `.docker/install.sh` bash script.

#### Make commands
**To run commands and scripts in the PHP container which contains Magento, use**
```
make enter
```
> Note: it is like login with SSH to a remote server

To flush the Redis storage:
```
make redis-flush (or make rf)
```
To shutdown the containers use:
```
make down
```
For more `make` options use:
```
make help
```

After this you can visit the following URLs:

Magento: [http://sandboxm2.localhost](http://artandsecret.localhost)\
phpMyAdmin: [http://phpmyadmin.localhost](http://phpmyadmin.localhost)\
MailHog: [http://mailhog.localhost](http://mailhog.localhost)\
Traefik: [http://traefik.localhost](http://traefik.localhost)

Magento admin username/password: admin/Admin1234\
Magento admin URL: sboxadmin

## Using HTTPS
If you want to visit the aforementioned URLs over HTTPS without security warnings, you must install the `RootCA.crt` certificate to your browser, found in the `.docker/traefik/certs` folder.

## Notes
To run PHP, Magento, Composer, etc. commands, make sure you run them in the php-fpm container (see `make enter`)!\
Git is not installed in any of the containers, so use the host machine's git command instead!

## List of used containers, volumes, networks
### Services
- applications; tianon/true (volume only container)
- php-fpm; php:7.4-fpm
- apache; apache:2.4.38-3+deb10u4
- redis; redis:6.0.8
- mariadb; mariadb:10.3.27
- traefik; traefik:1.7-alpine
- phpmyadmin; phpmyadmin/phpmyadmin
- mailhog; mailhog/mailhog
- elasticsearch; elasticsearch:7.9.3
### Volumes
- mysql (driver: local)
- redis (driver: local)
- elasticsearch (driver: local)
### Networks
- frontend (name: traefik; external)
- backend (driver: bridge)

## Maintainer(s):
- Bálint Bérczy <balint.berczy@ecommsolvers.com>
- Zoltán Németh <zoltan.nemeth@ecommsolvers.com>

:fire: **Happy developing!**