FROM whatsmycut/c7-systemd:latest
LABEL maintainer="mike@whatsmycut.com"
LABEL imagename=whatsmycut/docker-c7-systemd-j8-apache2:latest
# undocumented requirement for docker containers
ENV container=docker
# systemd init variables
ENV SYSTEMD_IGNORE_CHROOT=true
ENV init /lib/systemd/systemd
ENV HOSTNAME=localhost
ADD . /usr/local/dev
RUN chmod +x /usr/local/dev/*.sh

## additional yum packages
RUN yum -y update; yum install -y yum-plugin-ovl yum-utils epel-release \
 initscripts autoconf expat-devel libtool pcre pcre-devel bind bind-utils
RUN yum install -y make vim which

# Install Java 8
RUN ["/bin/sh", "-c", "/usr/local/dev/install-java8-src.sh"]
# install npm and node
RUN yum -y install nodejs npm ant maven gulp

# Install httpd
# This does not enable any Apache Modules. Set those using `LoadModule` in the `httpd.conf` file.
# APR (Apache Portable Runtime), OpenSSL, ufw (Uncomplicated Firewall)
RUN yum -y install apr apr-devel apr-util apr-util-devel openssl openssl-devel libnghttp2 libnghttp2-devel
RUN yum -y remove httpd; yum -y clean all
# Install Apache 2
RUN ["/bin/sh", "-c", "/usr/local/dev/install-httpd-src.sh"]
COPY httpd.service /etc/systemd/system/httpd.service
COPY httpd-default.conf  /usr/local/apache2/conf/httpd.conf
COPY httpd-vhosts.conf /usr/local/apache2/conf/extra/httpd-vhosts.conf
RUN systemctl enable httpd.service
RUN echo "pathmunge /usr/local/apache2/bin" >> /etc/profile.d/httpd.sh; \
groupadd www; \
useradd httpd -g www --no-create-home --shell /sbin/nologin;
RUN mkdir /usr/local/apache2/htdocs/vhosts/; mkdir /usr/local/apache2/htdocs/vhosts/localhost; \
mkdir /usr/local/apache2/htdocs/vhosts/localhost/logs/; chmod -R 775 /usr/local/apache2/htdocs/vhosts/

# Copy the systemd file and set the run levels
# COPY httpd.systemd /etc/init.d/httpd
# RUN find / -name *update*; \
# chkconfig --add httpd;  \
# touch /etc/sysconfig/httpd; chkconfig --level 2345 httpd on; \
# sysctl -p -a;

# Enable services
RUN touch /etc/sysconfig/network; chkconfig --level 2345 network on;
### named (dns server) service
RUN systemctl enable named.service
RUN systemctl mask proc-sys-fs-binfmt_misc.automount;
RUN echo "<html><body><h1>Apache</h1></body></html>" > /usr/local/apache2/htdocs/vhosts/localhost/index.html;
RUN chkconfig --list;
EXPOSE 80 443 9001
VOLUME ["/sys/fs/cgroup"]
ENTRYPOINT [ "/usr/local/dev/docker-entrypoint.sh" ]
CMD ["/usr/sbin/init"]
