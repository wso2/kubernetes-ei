#!/usr/bin/env bash

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

# Product Context
product=wso2ei
version=6.1.1
profile=analytics
patternNumber=1
# Image Build Context
imageBuildModule=../../../../modules/build-images
tmp=${imageBuildModule}/tmp
srcFiles=${imageBuildModule}/source-files
addedFiles=./files
dstFiles=${imageBuildModule}/dockerfile/common/provision/default/files

# Source
if [ -d "${tmp}" ]
    then
        rm -rf ${tmp}/*
    else
        mkdir ${tmp}
fi

echo "Creating WSO2 Distribution for ${profile} - pattern ${patternNumber} ..."
unzip -q ${srcFiles}/${product}-*.zip -d ${tmp}/

cp -r ${addedFiles}/* ${tmp}/${product}-*/

pushd ${tmp}/ > /dev/null 2>&1

zip -r ${product}-${version}.zip ${product}-* > /dev/null 2>&1

popd > /dev/null 2>&1

echo "Moving both JDK and ${profile} Distribution to dockerfile build context ..."
mv ${tmp}/${product}-*.zip ${dstFiles}/
cp -r ${srcFiles}/jdk-*.tar.gz ${dstFiles}/

rm -rf ${tmp}

/bin/bash ${imageBuildModule}/dockerfile/build.sh -l ${profile} -t ${product}-p${patternNumber}

rm ${dstFiles}/*.zip ${dstFiles}/*.tar.gz

echo "Image created: ${product}-p${patternNumber}-${profile}:${version}"
