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
wso2_server_profile=integrator

# custom WSO2 non-root user and group variables
user=wso2carbon
group=wso2

# file path variables
working_directory=/home/${user}
wso2_server_home=${working_directory}/${wso2_server}-${wso2_server_version}
volumes=${working_directory}/volumes
k8s_volumes=${working_directory}/kubernetes-volumes

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
if test ! -d ${wso2_server_home}; then
    echo "WSO2 Docker product home does not exist"
    exit 1
fi

# check if any changed configuration files have been mounted, using K8s ConfigMap volumes
# since, K8s does not support building ConfigMaps recursively from a directory, each folder has been separately
# mounted in the form of a K8s ConfigMap volume
# yet, only files with configuration changes mounted at <WSO2_USER_HOME>/volumes will be copied into the product pack
# hence, the files that were originally mounted using K8s ConfigMap volumes, need to be copied into <WSO2_USER_HOME>/volumes
if test -d ${k8s_volumes}/${wso2_server_profile}/conf; then
    # if a ConfigMap volume containing WSO2 configuration files has been mounted
    if ! test -d ${volumes}/repository/conf; then
        mkdir -p ${volumes}/repository/conf
    fi
    cp -r ${k8s_volumes}/${wso2_server_profile}/conf/* ${volumes}/repository/conf
fi

if test -d ${k8s_volumes}/${wso2_server_profile}/conf-axis2; then
    # if a ConfigMap volume containing WSO2 axis2 configuration files has been mounted
    if ! test -d ${volumes}/repository/conf/axis2; then
        mkdir -p ${volumes}/repository/conf/axis2
    fi
    cp -r ${k8s_volumes}/${wso2_server_profile}/conf-axis2/* ${volumes}/repository/conf/axis2
fi

if test -d ${k8s_volumes}/${wso2_server_profile}/conf-datasources; then
    # if a ConfigMap volume containing WSO2 data source configuration files has been mounted
    if ! test -d ${volumes}/repository/conf/datasources; then
        mkdir -p ${volumes}/repository/conf/datasources
    fi
    cp -r ${k8s_volumes}/${wso2_server_profile}/conf-datasources/* ${volumes}/repository/conf/datasources
fi

if test -d ${k8s_volumes}/${wso2_server_profile}/lib; then
    # if a ConfigMap volume containing external libraries has been mounted
    if ! test -d ${volumes}/repository/components/lib; then
        mkdir -p ${volumes}/repository/components/lib
    fi
    cp -r ${k8s_volumes}/${wso2_server_profile}/lib/* ${volumes}/repository/components/lib
fi

# check if any changed configuration files have been mounted
if test -d ${volumes}/repository/conf; then
    # if a ConfigMap volume has been mounted, copy the WSO2 configuration files recursively
    cp -r ${volumes}/repository/conf/* ${wso2_server_home}/conf
fi

# check if the external library directories have been mounted
# if mounted, recursively copy the external libraries to original directories within the product home
if test -d ${volumes}/repository/components/dropins; then
    cp -r ${volumes}/repository/components/dropins/* ${wso2_server_home}/dropins
fi

if test -d ${volumes}/repository/components/extensions; then
    cp -r ${volumes}/repository/components/extensions/* ${wso2_server_home}/extensions
fi

if test -d ${volumes}/repository/components/lib; then
    cp -r ${volumes}/repository/components/lib/* ${wso2_server_home}/lib
fi

# set the Docker container IP as the `localMemberHost` under axis2.xml clustering configurations (effective only when clustering is enabled)
sed -i "s#<parameter\ name=\"localMemberHost\".*<\/parameter>#<parameter\ name=\"localMemberHost\">${docker_container_ip}<\/parameter>#" ${wso2_server_home}/conf/axis2/axis2.xml

# set the ownership of the WSO2 product server home
chown -R ${user}:${group} ${wso2_server_home}

# start the WSO2 Carbon server
sh ${wso2_server_home}/bin/integrator.sh
