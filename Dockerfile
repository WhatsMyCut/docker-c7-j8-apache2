FROM whatsmycut/c7-systemd:latest
LABEL maintainer "mike@whatsmycut.com"
# undocumented requirement for docker containers
ENV container=docker
# systemd init variables
ENV SYSTEMD_IGNORE_CHROOT=true
ENV init /lib/systemd/systemd
ENV HOSTNAME=localhost
ADD . /usr/local/dev
RUN mkdir /var/www; mkdir /var/www/html; chmod -R 775 /var/www/html;
RUN chmod +x /usr/local/dev/*.sh

# yum package update for latest systemd

## additional yum packages
RUN yum install -y yum-plugin-ovl epel-release initscripts autoconf expat-devel libtool pcre pcre-devel bind bind-utils
RUN yum install -y make vim which ant maven


# Install Java 8
RUN ["/bin/sh", "-c", "/usr/local/dev/install-java8-src.sh"]

# Install httpd
# This does not enable any Apache Modules. Set those using `LoadModule` in the `httpd.conf` file.
# APR (Apache Portable Runtime) & OpenSSL
RUN yum -y install apr apr-devel apr-util apr-util-devel openssl openssl-devel libnghttp2 libnghttp2-devel
# Install Apache 2
RUN ["/bin/sh", "-c", "/usr/local/dev/install-httpd-src.sh"]
# RUN /usr/local/dev/install-httpd-src.sh
RUN cp /usr/local/dev/httpd.service /etc/systemd/system/httpd.service; \
systemctl enable httpd.service; \
ls -al /usr/local/apache2; \
cp /usr/local/dev/httpd.conf /usr/local/apache2/conf/httpd.conf;

# TODO: myserver test
# COPY someserver /etc/init.d/
# RUN find / -name *update*; \
# chkconfig --add someserver;  \
# sysctl -p -a;

# Enable services
RUN touch /etc/sysconfig/network; chkconfig --level 2345 network on;
### named (dns server) service
RUN systemctl enable named.service
RUN systemctl mask proc-sys-fs-binfmt_misc.automount;
RUN chkconfig --list;
RUN echo "<html><body><h1>PHPInfo</h1><?php phpinfo(); ?></body></html>" > /usr/local/apache2/htdocs/index.php; \
echo "pathmunge /usr/local/apache2/bin" >> /etc/profile.d/httpd.sh; \
groupadd www; \
useradd httpd -g www --no-create-home --shell /sbin/nologin; \
cd /usr/local/apache2/htdocs;
EXPOSE 80 443
VOLUME ["/sys/fs/cgroup"]
ENTRYPOINT [ "/usr/sbin/init" ]
CMD ["systemctl", "restart", "autofs"]
