# docker-c7-j8-apache2

## Quick Start

To run this image from the command line:

```
docker pull whatsmycut/c7-systemd-j8:latest
docker run -it --privileged --cap-add SYS_ADMIN --rm -p 80:80/tcp -p 443:44
3/tcp whatsmycut/c7-systemd-j8:latest
```

You can add `--entrypoint="/usr/local/dev/docker-entrypoint.sh` before the image name to fully start up and enter into a shell after setting the `root` password to whatever you like.

## Project Info

Based on the `whatsmycut/c7-systemd` enhanced CentOS:7 dockerized core, this image adds Java 8u201 and Apache2 on Port 80 from source distributions with default configuration files located in `/usr/local/java/` and `/usr/local/apache2` respectively.

The `httpd.service` file is used to create the Apache2 daemon by `systemd` during initialization, and is located in the `/etc/systemd/system/` directory.

The `httpd.conf` file is the default Apache2 optimized configuration file, and is located in the `/usr/local/apache2/conf/` directory.

The default `DocumentRoot` is located in the `/usr/local/apache2/htdocs/` directory, and can be overridden using `.htaccess` files in any given subdirectory. The user and group for Apache is `www:www`.

### Adding PHP

You can add PHP to the server by following the instructions to login as `root` above, then run `/usr/local/dev/install-php-src.sh`. (This takes a while, so grab a tasty beverage.)
