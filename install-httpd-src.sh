#!/bin/bash
curl -LO https://www-us.apache.org/dist/httpd/httpd-2.4.37.tar.gz;
tar -xzf httpd-2.4.37.tar.gz;
rm *.gz;
cd httpd-2.4.37;
./buildconf
./configure --enable-ssl --enable-so --with-ssl=/usr/bin/  --enable-http2 --prefix=/usr/local/apache2
make;
make install;
