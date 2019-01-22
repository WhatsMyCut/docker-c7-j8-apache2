#!/bin/bash
# Prepare environment
export JAVA_HOME=/usr/local/java
# Install Oracle Java8
# https://download.oracle.com/otn-pub/java/jdk/8u201-b09/42970487e3af4f5aa5bca3f542482c60/jdk-8u201-linux-i586.tar.gz
export JAVA_VERSION=8u201
export JAVA_BUILD=8u201-b09
export JAVA_DL_HASH=42970487e3af4f5aa5bca3f542482c60
cd /usr/local/dev/;
curl -LOb "oraclelicense=a" \
 http://download.oracle.com/otn-pub/java/jdk/${JAVA_BUILD}/${JAVA_DL_HASH}/jre-${JAVA_VERSION}-linux-x64.rpm;
yum localinstall -y jre-${JAVA_VERSION}-linux-x64.rpm;
rm *.rpm;
java -version
