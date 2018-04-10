#!/bin/sh

# ------------------------------------------------------------------------
# Copyright 2018 WSO2, Inc. (http://wso2.com)
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
set -e

# product related variables
wso2_server=wso2ei
wso2_server_version=6.1.1
wso2_server_profile=analytics

# custom WSO2 non-root user and group variables
user=wso2carbon
group=wso2

# file path variables
working_directory=/home/${user}
wso2_server_home=${working_directory}/${wso2_server}-${wso2_server_version}
wso2_server_profile_home=${wso2_server_home}/wso2/${wso2_server_profile}
volumes=${working_directory}/volumes

# capture the Docker container IP from the container's /etc/hosts file
docker_container_ip=$(awk 'END{print $1}' /etc/hosts)

# check if the WSO2 non-root user has been created
id ${user} >/dev/null 2>&1

# check if the WSO2 non-root group has been created
if ! [ $(getent group ${group}) ]; then
    echo "WSO2 Docker non-root group does not exist"
    exit 1
fi

# check if the WSO2 non-root user home exists
if test ! -d ${working_directory}; then
    echo "WSO2 Docker non-root user home does not exist"
    exit 1
fi

# check if the WSO2 product home exists
if test ! -d ${wso2_server_profile_home}; then
    echo "WSO2 Docker product home does not exist"
    exit 1
fi

# check if any changed configuration files have been mounted
if test -d ${volumes}/repository/conf; then
    # if any file changes have been mounted, copy the WSO2 configuration files recursively
    cp -r ${volumes}/repository/conf/* ${wso2_server_profile_home}/conf
fi

# set the Docker container IP as the `localMemberHost` under axis2.xml clustering configurations (effective only when clustering is enabled)
sed -i "s#<parameter\ name=\"localMemberHost\".*<\/parameter>#<parameter\ name=\"localMemberHost\">${docker_container_ip}<\/parameter>#" ${wso2_server_profile_home}/conf/axis2/axis2.xml

# set the ownership of the WSO2 product server home
chown -R ${user}:${group} ${wso2_server_home}

# start the WSO2 Carbon server
sh ${wso2_server_home}/bin/${wso2_server_profile}.sh
