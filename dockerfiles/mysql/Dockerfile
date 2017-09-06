# ------------------------------------------------------------------------
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
# ------------------------------------------------------------------------

FROM mysql:5.7
MAINTAINER WSO2 Docker Maintainers "dev@wso2.org"

# files
ARG FILES=./files
# database scripts
ARG HOME=/home
ARG WSO2_SERVER=wso2ei
ARG WSO2_SERVER_VERSION=6.1.1
ARG WSO2_SERVER_DB_SCRIPTS=${HOME}/${WSO2_SERVER}-${WSO2_SERVER_VERSION}-db-scripts

# Copy Files
COPY ["${FILES}/my.cnf", "/etc/mysql/conf.d/"]
COPY ["${FILES}/init.sql", "/docker-entrypoint-initdb.d/"]
COPY ["${FILES}/config-user-mgt.sql", "${WSO2_SERVER_DB_SCRIPTS}/"]

# Expose transport ports
EXPOSE 3306
