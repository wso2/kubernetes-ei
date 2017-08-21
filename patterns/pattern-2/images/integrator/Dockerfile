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

FROM docker.wso2.com/wso2ei-integrator:6.1.1

# Arguments
ARG FILES=./files
ARG ROOT_USER=root
ARG ORDINARY_USER=wso2user

USER ${ROOT_USER}

# Copy Files
COPY ["${FILES}/.", "${USER_HOME}/${WSO2_SERVER}-${WSO2_SERVER_VERSION}/"]

RUN chown -R ${ORDINARY_USER} ${USER_HOME} \
    && chmod -R 0774 ${USER_HOME}

USER ${ORDINARY_USER}
