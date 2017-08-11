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

FROM ubuntu:latest
MAINTAINER WSO2 Docker Maintainers "dev@wso2.org"
ENV DEBIAN_FRONTEND noninteractive

# defined arguments and defaults
ARG USER=wso2user
ARG USER_HOME=/home/${USER}
ARG USER_ID=1000000000

ARG FILES=./files

ARG WSO2_SERVER=wso2ei
ARG WSO2_SERVER_VERSION=6.1.1
ARG WSO2_SERVER_PACK=${WSO2_SERVER}-${WSO2_SERVER_VERSION}.zip

ARG JAVA_HOME=${USER_HOME}/java
ARG JDK_ARCHIVE=jdk-8u131-linux-x64.tar.gz

ARG STARTUP_SCRIPT=analytics.sh

RUN apt-get update \
        && apt-get install -y --no-install-recommends --no-install-suggests \
           zip \
           unzip \
           telnet \
           iproute2

# creates the user
RUN useradd --system --uid ${USER_ID} --gid 0 --create-home --home-dir ${USER_HOME} \
        --no-log-init ${USER}

# copy the jdk and product packs
COPY ${FILES}/${JDK_ARCHIVE} ${FILES}/${WSO2_SERVER_PACK} ${USER_HOME}/

# and creates the init script
RUN unzip -q ${USER_HOME}/${WSO2_SERVER_PACK} -d ${USER_HOME}/ \
        && mkdir -p ${JAVA_HOME} \
        && tar -xf ${USER_HOME}/${JDK_ARCHIVE} -C ${JAVA_HOME} --strip-components=1 \
        && rm ${USER_HOME}/${WSO2_SERVER_PACK} \
        && rm ${USER_HOME}/${JDK_ARCHIVE} \
        && chgrp -R 0 ${USER_HOME} \
        && chown -R ${USER_ID} ${USER_HOME} \
        && chmod -R 0774 ${USER_HOME}

# set the user, work directory and home
USER ${USER_ID}
WORKDIR ${USER_HOME}

# set java home and path variables
ENV HOME=${USER_HOME} JAVA_HOME=${JAVA_HOME} PATH=$JAVA_HOME/bin:$PATH USER_HOME=${USER_HOME} \
        WSO2_SERVER=${WSO2_SERVER} WSO2_SERVER_VERSION=${WSO2_SERVER_VERSION}

# expose ports
EXPOSE 9764 9444 7612 7712

ENTRYPOINT exec ${USER_HOME}/${WSO2_SERVER}-${WSO2_SERVER_VERSION}/bin/${STARTUP_SCRIPT}
