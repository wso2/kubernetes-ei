--
-- Copyright 2017 WSO2 Inc. (http://wso2.org)
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--

DROP DATABASE IF EXISTS WSO2EI_USER_DB;
DROP DATABASE IF EXISTS WSO2EI_INTEGRATOR_CONFIG_GOV_DB;

CREATE DATABASE WSO2EI_USER_DB;
CREATE DATABASE WSO2EI_INTEGRATOR_CONFIG_GOV_DB;

CREATE USER IF NOT EXISTS 'wso2carbon'@'%' IDENTIFIED BY 'wso2carbon';
GRANT ALL ON WSO2EI_USER_DB.* TO 'wso2carbon'@'%' IDENTIFIED BY 'wso2carbon';
GRANT ALL ON WSO2EI_INTEGRATOR_CONFIG_GOV_DB.* TO 'wso2carbon'@'%' IDENTIFIED BY 'wso2carbon';

USE WSO2EI_USER_DB;
source /home/wso2ei-6.1.1-db-scripts/config-user-mgt.sql;
USE WSO2EI_INTEGRATOR_CONFIG_GOV_DB;
source /home/wso2ei-6.1.1-db-scripts/config-user-mgt.sql;
