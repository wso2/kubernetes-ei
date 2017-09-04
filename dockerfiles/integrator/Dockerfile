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

FROM wso2ei-kubernetes-base:6.1.1

# expose ports
EXPOSE 8280 8243 9763 9443

CMD mkdir -p ${USER_HOME}/${WSO2_SERVER}-${WSO2_SERVER_VERSION}-conf/integrator/ \
    && cp ${USER_HOME}/${WSO2_SERVER}-${WSO2_SERVER_VERSION}-conf/integrator/conf/* ${WSO2_SERVER_HOME}/conf/ \
    && cp ${USER_HOME}/${WSO2_SERVER}-${WSO2_SERVER_VERSION}-conf/integrator/conf-axis2/* ${WSO2_SERVER_HOME}/conf/axis2/ \
    && cp ${USER_HOME}/${WSO2_SERVER}-${WSO2_SERVER_VERSION}-conf/integrator/conf-datasources/* ${WSO2_SERVER_HOME}/conf/datasources/ \
    && ${WSO2_SERVER_HOME}/bin/integrator.sh -Dsetup
