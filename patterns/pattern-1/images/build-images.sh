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
patternNumber=1

pushd ./mysql-test-node/ > /dev/null 2>&1
/bin/bash build-image.sh
popd > /dev/null 2>&1

pushd ./analytics-node/ > /dev/null 2>&1
/bin/bash build-image.sh
popd > /dev/null 2>&1

pushd ./integrator-node/ > /dev/null 2>&1
/bin/bash build-image.sh
popd > /dev/null 2>&1
