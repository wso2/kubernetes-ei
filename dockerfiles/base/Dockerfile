# ------------------------------------------------------------------------
#
# Copyright 2017 WSO2, Inc. (http://wso2.com)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License
#
# ------------------------------------------------------------------------

FROM ubuntu:17.04
MAINTAINER WSO2 Docker Maintainers "dev@wso2.org"
ENV DEBIAN_FRONTEND noninteractive

# user information
ARG HOME=/home
ARG USER=wso2user
ARG USER_ID=1000000000
ARG USER_HOME=${HOME}/${USER}
# files
ARG FILES=./files
# product information
ARG WSO2_SERVER=wso2ei
ARG WSO2_SERVER_VERSION=6.1.1
ARG WSO2_SERVER_PACK=${WSO2_SERVER}-${WSO2_SERVER_VERSION}.zip
ARG WSO2_SERVER_HOME=${USER_HOME}/${WSO2_SERVER}-${WSO2_SERVER_VERSION}
# jdk information
ARG JDK_ARCHIVE=jdk-8u*-linux-x64.tar.gz
ARG JAVA_HOME=${USER_HOME}/java
# jdbc driver
ARG JDBC_DRIVER=mysql-connector-java-5*-bin.jar

RUN apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests unzip telnet iproute2 \
	&& rm -rf /var/lib/apt/lists/*

# create the user
RUN useradd --system --uid ${USER_ID} --gid 0 --create-home --home-dir ${USER_HOME} --no-log-init ${USER}

# copy the jdk, wso2 product distribution and jdbc driver
COPY ${FILES}/${JDK_ARCHIVE} ${FILES}/${WSO2_SERVER_PACK} ${FILES}/${JDBC_DRIVER} ${USER_HOME}/

# install the jdk, wso2 server, remove distributions and set folder permissions
RUN unzip -q ${USER_HOME}/${WSO2_SERVER_PACK} -d ${USER_HOME}/ \
    && mkdir -p ${JAVA_HOME} \
    && tar -xf ${USER_HOME}/${JDK_ARCHIVE} -C ${JAVA_HOME} --strip-components=1 \
    && cp ${USER_HOME}/${JDBC_DRIVER} ${WSO2_SERVER_HOME}/lib/ \
    && rm ${USER_HOME}/${WSO2_SERVER_PACK} \
    && rm ${USER_HOME}/${JDK_ARCHIVE} \
    && rm ${USER_HOME}/${JDBC_DRIVER} \
    && chgrp -R 0 ${USER_HOME} \
    && chown -R ${USER_ID} ${USER_HOME} \
    && chmod -R 0774 ${USER_HOME}

# set the user and work directory
USER ${USER_ID}
WORKDIR ${USER_HOME}

# set environment variables
ENV JAVA_HOME=${JAVA_HOME} \
    PATH=$JAVA_HOME/bin:$PATH \
    USER_HOME=${USER_HOME} \
    WSO2_SERVER=${WSO2_SERVER} \
    WSO2_SERVER_VERSION=${WSO2_SERVER_VERSION} \
    WSO2_SERVER_HOME=${WSO2_SERVER_HOME}
