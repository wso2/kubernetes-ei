#!/bin/bash

#-------------------------------------------------------------------------------
# Copyright (c) 2019, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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
# limitations under the License.
#-------------------------------------------------------------------------------

set -e
# bash variables
k8s_obj_file="deployment.yaml"; NODE_IP=''; str_sec=""

# wso2 subscription variables
WUMUsername=''; WUMPassword=''
IMG_DEST="docker.wso2.com"

: ${namespace:="wso2"}
: ${randomPort:=true}; : ${NP_1:=30443}; : ${NP_2:=30243}; : ${NP_3:=30643}

# testgrid directory
OUTPUT_DIR=$4; INPUT_DIR=$2; TG_PROP="$INPUT_DIR/infrastructure.properties"

function create_yaml(){
cat > $k8s_obj_file << "EOF"
EOF
if [ "$namespace" == "wso2" ]; then
cat >> $k8s_obj_file << "EOF"
apiVersion: v1
kind: Namespace
metadata:
  name: wso2
spec:
  finalizers:
    - kubernetes
---
EOF
fi
cat >> $k8s_obj_file << "EOF"

apiVersion: v1
kind: ServiceAccount
metadata:
  name: wso2svc-account
  namespace: "$ns.k8s&wso2.ei"
secrets:
  - name: wso2svc-account-token-t7s49
---

apiVersion: v1
data:
  .dockerconfigjson: "$string.&.secret.auth.data"
kind: Secret
metadata:
  name: wso2creds
  namespace: "$ns.k8s&wso2.ei"
type: kubernetes.io/dockerconfigjson
---

apiVersion: v1
data:
  carbon.xml: |
    <?xml version="1.0" encoding="ISO-8859-1"?>
    <Server xmlns="http://wso2.org/projects/carbon/carbon.xml">
        <Name>WSO2 Enterprise Integrator</Name>
        <ServerKey>EI</ServerKey>
        <Version>6.5.0</Version>
        <HostName>"ip.node.k8s.&.wso2.ei"</HostName>
        <MgtHostName>wso2ei-integrator</MgtHostName>
        <ServerURL>local:/${carbon.context}/services/</ServerURL>
        <ServerRoles>
            <Role>EnterpriseIntegrator</Role>
            <Role>EnterpriseServiceBus</Role>
            <Role>DataServicesServer</Role>
        </ServerRoles>
        <Package>org.wso2.carbon</Package>
        <WebContextRoot>/</WebContextRoot>
        <ItemsPerPage>15</ItemsPerPage>
        <Ports>
            <Offset>0</Offset>
            <JMX>
                <RMIRegistryPort>9999</RMIRegistryPort>
                <RMIServerPort>11111</RMIServerPort>
            </JMX>
            <EmbeddedLDAP>
                <LDAPServerPort>10389</LDAPServerPort>
                <KDCServerPort>8000</KDCServerPort>
            </EmbeddedLDAP>
            <ThriftEntitlementReceivePort>10500</ThriftEntitlementReceivePort>
        </Ports>
        <JNDI>
            <DefaultInitialContextFactory>org.wso2.carbon.tomcat.jndi.CarbonJavaURLContextFactory</DefaultInitialContextFactory>
            <Restrictions>
                <AllTenants>
                    <UrlContexts>
                        <UrlContext>
                            <Scheme>java</Scheme>
                        </UrlContext>
                    </UrlContexts>
                </AllTenants>
            </Restrictions>
        </JNDI>
        <IsCloudDeployment>false</IsCloudDeployment>
        <EnableMetering>false</EnableMetering>
        <MaxThreadExecutionTime>600</MaxThreadExecutionTime>
        <GhostDeployment>
            <Enabled>false</Enabled>
        </GhostDeployment>
        <Tenant>
            <LoadingPolicy>
                <LazyLoading>
                    <IdleTime>30</IdleTime>
                </LazyLoading>
            </LoadingPolicy>
        </Tenant>
        <Cache>
            <DefaultCacheTimeout>15</DefaultCacheTimeout>
        </Cache>
        <Axis2Config>
            <RepositoryLocation>${carbon.home}/repository/deployment/server/</RepositoryLocation>
            <DeploymentUpdateInterval>15</DeploymentUpdateInterval>
            <ConfigurationFile>${carbon.home}/conf/axis2/axis2.xml</ConfigurationFile>
            <ServiceGroupContextIdleTime>30000</ServiceGroupContextIdleTime>
            <ClientRepositoryLocation>${carbon.home}/repository/deployment/client/</ClientRepositoryLocation>
            <clientAxis2XmlLocation>${carbon.home}/conf/axis2/axis2_client.xml</clientAxis2XmlLocation>
            <HideAdminServiceWSDLs>true</HideAdminServiceWSDLs>
        </Axis2Config>
        <ServiceUserRoles>
            <Role>
                <Name>admin</Name>
                <Description>Default Administrator Role</Description>
            </Role>
            <Role>
                <Name>user</Name>
                <Description>Default User Role</Description>
            </Role>
        </ServiceUserRoles>
        <CryptoService>
            <Enabled>true</Enabled>
            <InternalCryptoProviderClassName>org.wso2.carbon.crypto.provider.KeyStoreBasedInternalCryptoProvider</InternalCryptoProviderClassName>
            <ExternalCryptoProviderClassName>org.wso2.carbon.core.encryption.KeyStoreBasedExternalCryptoProvider</ExternalCryptoProviderClassName>
            <KeyResolvers>
                <KeyResolver className="org.wso2.carbon.crypto.defaultProvider.resolver.ContextIndependentKeyResolver" priority="-1"/>
            </KeyResolvers>
        </CryptoService>
        <Security>
            <KeyStore>
                <Location>${carbon.home}/repository/resources/security/wso2carbon.jks</Location>
                <Type>JKS</Type>
                <Password>wso2carbon</Password>
                <KeyAlias>wso2carbon</KeyAlias>
                <KeyPassword>wso2carbon</KeyPassword>
            </KeyStore>
            <InternalKeyStore>
                <Location>${carbon.home}/repository/resources/security/wso2carbon.jks</Location>
                <Type>JKS</Type>
                <Password>wso2carbon</Password>
                <KeyAlias>wso2carbon</KeyAlias>
                <KeyPassword>wso2carbon</KeyPassword>
            </InternalKeyStore>
            <TrustStore>
                <Location>${carbon.home}/repository/resources/security/client-truststore.jks</Location>
                <Type>JKS</Type>
                <Password>wso2carbon</Password>
            </TrustStore>
            <NetworkAuthenticatorConfig>
            </NetworkAuthenticatorConfig>
            <TomcatRealm>UserManager</TomcatRealm>
      <DisableTokenStore>false</DisableTokenStore>
            <XSSPreventionConfig>
                <Enabled>true</Enabled>
                <Rule>allow</Rule>
                <Patterns>
                </Patterns>
            </XSSPreventionConfig>
        </Security>
        <WorkDirectory>${carbon.home}/tmp/work</WorkDirectory>
        <HouseKeeping>
            <AutoStart>true</AutoStart>
            <Interval>10</Interval>
            <MaxTempFileLifetime>30</MaxTempFileLifetime>
        </HouseKeeping>
        <FileUploadConfig>
            <TotalFileSizeLimit>100</TotalFileSizeLimit>
            <Mapping>
                <Actions>
                    <Action>keystore</Action>
                    <Action>certificate</Action>
                    <Action>*</Action>
                </Actions>
                <Class>org.wso2.carbon.ui.transports.fileupload.AnyFileUploadExecutor</Class>
            </Mapping>
            <Mapping>
                <Actions>
                    <Action>jarZip</Action>
                </Actions>
                <Class>org.wso2.carbon.ui.transports.fileupload.JarZipUploadExecutor</Class>
            </Mapping>
            <Mapping>
                <Actions>
                    <Action>dbs</Action>
                </Actions>
                <Class>org.wso2.carbon.ui.transports.fileupload.DBSFileUploadExecutor</Class>
            </Mapping>
            <Mapping>
                <Actions>
                    <Action>tools</Action>
                </Actions>
                <Class>org.wso2.carbon.ui.transports.fileupload.ToolsFileUploadExecutor</Class>
            </Mapping>
            <Mapping>
                <Actions>
                    <Action>toolsAny</Action>
                </Actions>
                <Class>org.wso2.carbon.ui.transports.fileupload.ToolsAnyFileUploadExecutor</Class>
            </Mapping>
        </FileUploadConfig>
        <HttpGetRequestProcessors>
            <Processor>
                <Item>info</Item>
                <Class>org.wso2.carbon.core.transports.util.InfoProcessor</Class>
            </Processor>
            <Processor>
                <Item>wsdl</Item>
                <Class>org.wso2.carbon.core.transports.util.Wsdl11Processor</Class>
            </Processor>
            <Processor>
                <Item>wsdl2</Item>
                <Class>org.wso2.carbon.core.transports.util.Wsdl20Processor</Class>
            </Processor>
            <Processor>
                <Item>xsd</Item>
                <Class>org.wso2.carbon.core.transports.util.XsdProcessor</Class>
            </Processor>
        </HttpGetRequestProcessors>
        <DeploymentSynchronizer>
            <Enabled>false</Enabled>
            <AutoCommit>false</AutoCommit>
            <AutoCheckout>true</AutoCheckout>
            <RepositoryType>svn</RepositoryType>
            <SvnUrl>http://svnrepo.example.com/repos/</SvnUrl>
            <SvnUser>username</SvnUser>
            <SvnPassword>password</SvnPassword>
            <SvnUrlAppendTenantId>true</SvnUrlAppendTenantId>
        </DeploymentSynchronizer>
        <ServerInitializers>
        </ServerInitializers>
        <RequireCarbonServlet>${require.carbon.servlet}</RequireCarbonServlet>
        <StatisticsReporterDisabled>true</StatisticsReporterDisabled>
        <FeatureRepository>
          <RepositoryName>default repository</RepositoryName>
          <RepositoryURL>http://product-dist.wso2.com/p2/carbon/releases/wilkes/</RepositoryURL>
        </FeatureRepository>
       <APIManagement>
      <Enabled>true</Enabled>
      <LoadAPIContextsInServerStartup>true</LoadAPIContextsInServerStartup>
       </APIManagement>

       <Analytics>

            <ServerURL>tcp://wso2ei-with-analytics-worker-service:7612</ServerURL>
            <AuthServerURL>ssl://wso2ei-with-analytics-worker-service:7712</AuthServerURL>

            <Username>admin</Username>
            <Password>admin</Password>
       </Analytics>
    </Server>
  registry.xml: |
    <?xml version="1.0" encoding="ISO-8859-1"?>
    <wso2registry>
        <currentDBConfig>wso2registry</currentDBConfig>
        <readOnly>false</readOnly>
        <enableCache>true</enableCache>
        <registryRoot>/</registryRoot>
        <dbConfig name="wso2registry">
            <dataSource>jdbc/WSO2CarbonDB</dataSource>
        </dbConfig>
        <dbConfig name="wso2config">
            <dataSource>jdbc/WSO2ConfigDB</dataSource>
        </dbConfig>
        <remoteInstance url="https://localhost:9453/registry">
            <id>wso2config</id>
            <dbConfig>wso2config</dbConfig>
            <readOnly>false</readOnly>
            <registryRoot>/</registryRoot>
        </remoteInstance>
        <mount path="/_system/config" overwrite="true">
            <instanceId>wso2config</instanceId>
            <targetPath>/_system/config/integrator</targetPath>
        </mount>
        <mount path="/_system/governance" overwrite="true">
            <instanceId>wso2config</instanceId>
            <targetPath>/_system/governance/integrator</targetPath>
        </mount>
        <indexingConfiguration>
            <skipCache>false</skipCache>
            <startIndexing>false</startIndexing>
            <startingDelayInSeconds>35</startingDelayInSeconds>
            <indexingFrequencyInSeconds>3</indexingFrequencyInSeconds>
            <batchSize>50</batchSize>
            <indexerPoolSize>50</indexerPoolSize>
            <lastAccessTimeLocation>/_system/local/repository/components/org.wso2.carbon.registry/indexing/lastaccesstime</lastAccessTimeLocation>
            <indexers>
                <indexer class="org.wso2.carbon.registry.indexing.indexer.MSExcelIndexer" mediaTypeRegEx="application/vnd.ms-excel"/>
                <indexer class="org.wso2.carbon.registry.indexing.indexer.MSPowerpointIndexer" mediaTypeRegEx="application/vnd.ms-powerpoint"/>
                <indexer class="org.wso2.carbon.registry.indexing.indexer.MSWordIndexer" mediaTypeRegEx="application/msword"/>
                <indexer class="org.wso2.carbon.registry.indexing.indexer.PDFIndexer" mediaTypeRegEx="application/pdf"/>
                <indexer class="org.wso2.carbon.registry.indexing.indexer.XMLIndexer" mediaTypeRegEx="application/xml"/>
                <indexer class="org.wso2.carbon.registry.indexing.indexer.XMLIndexer" mediaTypeRegEx="application/(.)+\+xml"/>
                <indexer class="org.wso2.carbon.registry.indexing.indexer.PlainTextIndexer" mediaTypeRegEx="application/swagger\+json"/>
                <indexer class="org.wso2.carbon.registry.indexing.indexer.PlainTextIndexer" mediaTypeRegEx="application/(.)+\+json"/>
                <indexer class="org.wso2.carbon.registry.indexing.indexer.PlainTextIndexer" mediaTypeRegEx="text/(.)+"/>
                <indexer class="org.wso2.carbon.registry.indexing.indexer.PlainTextIndexer" mediaTypeRegEx="application/x-javascript"/>
            </indexers>
            <exclusions>
                <exclusion pathRegEx="/_system/config/repository/dashboards/gadgets/swfobject1-5/.*[.]html"/>
                <exclusion pathRegEx="/_system/local/repository/components/org[.]wso2[.]carbon[.]registry/mount/.*"/>
            </exclusions>
        </indexingConfiguration>
        <handler class="org.wso2.carbon.mediation.library.RegistryCachingHandler">
            <filter class="org.wso2.carbon.registry.core.jdbc.handlers.filters.URLMatcher">
                <property name="putPattern">.*</property>
                <property name="movePattern">.*</property>
                <property name="renamePattern">.*</property>
                <property name="deletePattern">.*</property>
            </filter>
        </handler>
        <versionResourcesOnChange>false</versionResourcesOnChange>
        <staticConfiguration>
            <versioningProperties>true</versioningProperties>
            <versioningComments>true</versioningComments>
            <versioningTags>true</versioningTags>
            <versioningRatings>true</versioningRatings>
        </staticConfiguration>
    </wso2registry>
  synapse.properties: |
    synapse.sal.endpoints.sesssion.timeout.default=600000
    synapse.global_timeout_interval=120000
    statistics.clean.enable=true
    statistics.clean.interval=1000
    synapse.observers=org.wso2.carbon.mediation.dependency.mgt.DependencyTracker
    synapse.commons.json.preserve.namespace=false
    synapse.temp_data.chunk.size=3072
    synapse.carbon.ext.tenant.info=org.wso2.carbon.mediation.initializer.handler.CarbonTenantInfoConfigurator
    synapse.carbon.ext.tenant.info.initiator=org.wso2.carbon.mediation.initializer.handler.CarbonTenantInfoInitiator
    synapse.xpath.func.extensions=org.wso2.carbon.mediation.security.vault.xpath.SecureVaultLookupXPathFunctionProvider
    synapse.debugger.port.command=9005
    synapse.debugger.port.event=9006
    mediation.flow.statistics.enable=true
    mediation.flow.statistics.tracer.collect.payloads=true
    mediation.flow.statistics.tracer.collect.properties=true
    mediation.flow.statistics.event.consume.interval=1000
    mediation.flow.statistics.event.clean.interval=15000
    mediation.flow.statistics.collect.all=true
    internal.http.api.enabled=true
    internal.http.api.port=9191
    internal.https.api.port=9154
  user-mgt.xml: |
    <UserManager>
        <Realm>
            <Configuration>
    		<AddAdmin>true</AddAdmin>
                <AdminRole>admin</AdminRole>
                <AdminUser>
                    <UserName>admin</UserName>
                    <Password>admin</Password>
                </AdminUser>
                <EveryOneRoleName>everyone</EveryOneRoleName> <!-- By default users in this role sees the registry root -->
                <Property name="isCascadeDeleteEnabled">true</Property>
                <Property name="dataSource">jdbc/WSO2UserDB</Property>
            </Configuration>
            <UserStoreManager class="org.wso2.carbon.user.core.jdbc.JDBCUserStoreManager">
                <Property name="TenantManager">org.wso2.carbon.user.core.tenant.JDBCTenantManager</Property>
                <Property name="ReadOnly">false</Property>
                <Property name="ReadGroups">true</Property>
                <Property name="WriteGroups">true</Property>
                <Property name="UsernameJavaRegEx">^[\S]{3,30}$</Property>
                <Property name="UsernameJavaScriptRegEx">^[\S]{3,30}$</Property>
                <Property name="UsernameJavaRegExViolationErrorMsg">Username pattern policy violated</Property>
                <Property name="PasswordJavaRegEx">^[\S]{5,30}$</Property>
                <Property name="PasswordJavaScriptRegEx">^[\S]{5,30}$</Property>
                <Property name="PasswordJavaRegExViolationErrorMsg">Password length should be within 5 to 30 characters</Property>
                <Property name="RolenameJavaRegEx">^[\S]{3,30}$</Property>
                <Property name="RolenameJavaScriptRegEx">^[\S]{3,30}$</Property>
                <Property name="CaseInsensitiveUsername">true</Property>
                <Property name="SCIMEnabled">false</Property>
                <Property name="IsBulkImportSupported">true</Property>
                <Property name="PasswordDigest">SHA-256</Property>
                <Property name="StoreSaltedPassword">true</Property>
                <Property name="MultiAttributeSeparator">,</Property>
                <Property name="MaxUserNameListLength">100</Property>
                <Property name="MaxRoleNameListLength">100</Property>
                <Property name="UserRolesCacheEnabled">true</Property>
                <Property name="UserNameUniqueAcrossTenants">false</Property>
            </UserStoreManager>
            <AuthorizationManager class="org.wso2.carbon.user.core.authorization.JDBCAuthorizationManager">
                <Property name="AdminRoleManagementPermissions">/permission</Property>
                <Property name="AuthorizationCacheEnabled">true</Property>
                <Property name="GetAllRolesOfUserEnabled">false</Property>
            </AuthorizationManager>
        </Realm>
    </UserManager>
kind: ConfigMap
metadata:
  name: integrator-conf
  namespace: "$ns.k8s&wso2.ei"
---

apiVersion: v1
data:
  axis2.xml: |
    <axisconfig name="AxisJava2.0">
        <parameter name="hotdeployment" locked="false">true</parameter>
        <parameter name="hotupdate" locked="false">true</parameter>
        <parameter name="enableMTOM" locked="false">false</parameter>
        <parameter name="enableSwA" locked="false">false</parameter>
        <parameter name="cacheAttachments" locked="false">false</parameter>
        <parameter name="attachmentDIR" locked="false">work/mtom</parameter>
        <parameter name="sizeThreshold" locked="false">4000</parameter>
        <parameter name="disableREST" locked="false">false</parameter>
        <parameter name="Sandesha2StorageManager" locked="false">inmemory</parameter>
        <parameter name="servicePath" locked="false">services</parameter>
        <parameter name="ServicesDirectory">axis2services</parameter>
        <parameter name="httpContentNegotiation">false</parameter>
        <parameter name="ModulesDirectory">axis2modules</parameter>
        <parameter name="userAgent" locked="true">WSO2 EI 6.5.0</parameter>
        <parameter name="server" locked="true">WSO2 EI 6.5.0</parameter>
        <parameter name="sendStacktraceDetailsWithFaults" locked="false">false</parameter>
        <parameter name="DrillDownToRootCauseForFaultReason" locked="false">false</parameter>
        <parameter name="manageTransportSession">true</parameter>
        <parameter name="ConfigContextTimeoutInterval" locked="false">30000</parameter>
        <parameter name="SynapseConfig.ConfigurationFile" locked="false">repository/deployment/server/synapse-configs</parameter>
        <parameter name="SynapseConfig.HomeDirectory" locked="false">.</parameter>
        <parameter name="SynapseConfig.ResolveRoot" locked="false">.</parameter>
        <parameter name="SynapseConfig.ServerName" locked="false">localhost</parameter>
        <parameter name="enableBasicAuth" locked="false">true</parameter>
        <listener class="org.wso2.carbon.core.deployment.DeploymentInterceptor"/>
        <messageReceivers>
            <messageReceiver mep="http://www.w3.org/ns/wsdl/in-only"
                             class="org.apache.axis2.rpc.receivers.RPCInOnlyMessageReceiver"/>
            <messageReceiver mep="http://www.w3.org/ns/wsdl/robust-in-only"
                             class="org.apache.axis2.rpc.receivers.RPCInOnlyMessageReceiver"/>
            <messageReceiver mep="http://www.w3.org/ns/wsdl/in-out"
                             class="org.apache.axis2.rpc.receivers.RPCMessageReceiver"/>
        </messageReceivers>
       <messageFormatters>
            <messageFormatter contentType="application/x-www-form-urlencoded"
                              class="org.apache.synapse.commons.formatters.XFormURLEncodedFormatter"/>
            <messageFormatter contentType="multipart/form-data"
                              class="org.apache.axis2.transport.http.MultipartFormDataFormatter"/>
            <messageFormatter contentType="application/xml"
                              class="org.apache.axis2.transport.http.ApplicationXMLFormatter"/>
            <messageFormatter contentType="text/xml"
                             class="org.apache.axis2.transport.http.SOAPMessageFormatter"/>
            <messageFormatter contentType="application/soap+xml"
                             class="org.apache.axis2.transport.http.SOAPMessageFormatter"/>
            <messageFormatter contentType="text/plain"
                             class="org.apache.axis2.format.PlainTextFormatter"/>
            <messageFormatter contentType="application/octet-stream"
                              class="org.wso2.carbon.relay.ExpandingMessageFormatter"/>
            <messageFormatter contentType="application/json"
                              class="org.wso2.carbon.integrator.core.json.JsonStreamFormatter"/>
        </messageFormatters>
        <messageBuilders>
            <messageBuilder contentType="application/xml"
                            class="org.apache.axis2.builder.ApplicationXMLBuilder"/>
            <messageBuilder contentType="application/x-www-form-urlencoded"
                            class="org.apache.synapse.commons.builders.XFormURLEncodedBuilder"/>
            <messageBuilder contentType="multipart/form-data"
                            class="org.apache.axis2.builder.MultipartFormDataBuilder"/>
            <messageBuilder contentType="text/plain"
                            class="org.apache.axis2.format.PlainTextBuilder"/>
            <messageBuilder contentType="application/octet-stream"
                            class="org.wso2.carbon.relay.BinaryRelayBuilder"/>
            <messageBuilder contentType="application/json"
                            class="org.wso2.carbon.integrator.core.json.JsonStreamBuilder"/>
        </messageBuilders>
         <transportReceiver name="http" class="org.apache.synapse.transport.passthru.PassThroughHttpListener">
            <parameter name="port" locked="false">8280</parameter>
            <parameter name="non-blocking" locked="false">true</parameter>
            <parameter name="WSDLEPRPrefix" locked="false">"ip.node.k8s.&.wso2.ei":30280</parameter>
            <parameter name="httpGetProcessor" locked="false">org.wso2.carbon.mediation.transport.handlers.PassThroughNHttpGetProcessor</parameter>
        </transportReceiver>
         <transportReceiver name="https" class="org.apache.synapse.transport.passthru.PassThroughHttpSSLListener">
            <parameter name="port" locked="false">8243</parameter>
            <parameter name="non-blocking" locked="false">true</parameter>
            <parameter name="HttpsProtocols">TLSv1,TLSv1.1,TLSv1.2</parameter>
            <parameter name="WSDLEPRPrefix" locked="false">"ip.node.k8s.&.wso2.ei":"$nodeport.k8s.&.2.wso2ei"</parameter>
            <parameter name="httpGetProcessor" locked="false">org.wso2.carbon.mediation.transport.handlers.PassThroughNHttpGetProcessor</parameter>
            <parameter name="keystore" locked="false">
                <KeyStore>
                    <Location>repository/resources/security/wso2carbon.jks</Location>
                    <Type>JKS</Type>
                    <Password>wso2carbon</Password>
                    <KeyPassword>wso2carbon</KeyPassword>
                </KeyStore>
            </parameter>
            <parameter name="truststore" locked="false">
                <TrustStore>
                    <Location>repository/resources/security/client-truststore.jks</Location>
                    <Type>JKS</Type>
                    <Password>wso2carbon</Password>
                </TrustStore>
            </parameter>
        </transportReceiver>
        <transportReceiver name="local" class="org.wso2.carbon.core.transports.local.CarbonLocalTransportReceiver"/>
        <transportReceiver name="vfs" class="org.apache.synapse.transport.vfs.VFSTransportListener"/>

        <transportSender name="http" class="org.apache.synapse.transport.passthru.PassThroughHttpSender">
            <parameter name="non-blocking" locked="false">true</parameter>
        </transportSender>
        <transportSender name="https" class="org.apache.synapse.transport.passthru.PassThroughHttpSSLSender">
            <parameter name="non-blocking" locked="false">true</parameter>
            <parameter name="keystore" locked="false">
                <KeyStore>
                    <Location>repository/resources/security/wso2carbon.jks</Location>
                    <Type>JKS</Type>
                    <Password>wso2carbon</Password>
                    <KeyPassword>wso2carbon</KeyPassword>
                </KeyStore>
            </parameter>
            <parameter name="truststore" locked="false">
                <TrustStore>
                    <Location>repository/resources/security/client-truststore.jks</Location>
                    <Type>JKS</Type>
                    <Password>wso2carbon</Password>
                </TrustStore>
            </parameter>
        </transportSender>
        <transportSender name="local" class="org.wso2.carbon.core.transports.local.CarbonLocalTransportSender"/>
        <transportSender name="vfs" class="org.apache.synapse.transport.vfs.VFSTransportSender"/>

        <module ref="addressing"/>
        <clustering class="org.wso2.carbon.core.clustering.hazelcast.HazelcastClusteringAgent"
                    enable="false">
            <parameter name="clusteringPattern">nonWorkerManager</parameter>
            <parameter name="AvoidInitiation">true</parameter>
            <parameter name="membershipScheme">wka</parameter>
            <parameter name="membershipScheme">kubernetes</parameter>
            <parameter name="domain">wso2.carbon.domain</parameter>
            <parameter name="domain">wso2.ei.domain</parameter>
            <parameter name="mcastPort">45564</parameter>
            <parameter name="mcastTTL">100</parameter>
            <parameter name="mcastTimeout">60</parameter>
            <parameter name="localMemberHost">127.0.0.1</parameter>
             <parameter name="localMemberHost">integrator</parameter>
            <parameter name="localMemberPort">4100</parameter>
            <parameter name="properties">
                <property name="backendServerURL" value="https://${hostName}:${httpsPort}/services/"/>
                <property name="mgtConsoleURL" value="https://${hostName}:${httpsPort}/"/>
            </parameter>
            <members>
                <member>
                    <hostName>127.0.0.1</hostName>
                    <port>4000</port>
                </member>
            </members>
            <parameter name="membershipSchemeClassName">org.wso2.carbon.membership.scheme.kubernetes.KubernetesMembershipScheme</parameter>
            <parameter name="KUBERNETES_NAMESPACE">wso2</parameter>
            <parameter name="KUBERNETES_SERVICES">wso2ei-integrator-service</parameter>
            <parameter name="KUBERNETES_MASTER_SKIP_SSL_VERIFICATION">true</parameter>
            <parameter name="USE_DNS">false</parameter>
            <groupManagement enable="false">
                <applicationDomain name="wso2.esb.domain"
                                   description="EI group"
                                   agent="org.wso2.carbon.core.clustering.hazelcast.HazelcastGroupManagementAgent"
                                   subDomain="worker"
                                   port="2222"/>
            </groupManagement>
        </clustering>
        <phaseOrder type="InFlow">
            <phase name="MsgInObservation">
    	    <handler name="TraceMessageBuilderDispatchHandler"
                         class="org.apache.synapse.transport.passthru.util.TraceMessageBuilderDispatchHandler"/>
    	</phase>
            <phase name="Validation"/>
            <phase name="Transport">
                <handler name="IntegratorStatefulHandler" class="org.wso2.carbon.integrator.core.handler.IntegratorStatefulHandler">
                    <order phase="Transport"/>
                    <handler name="JSONMessageHandler"
                             class="org.apache.axis2.json.gson.JSONMessageHandler" />
                </handler>
       	        <handler name="CarbonContextConfigurator"
                         class="org.wso2.carbon.mediation.initializer.handler.CarbonContextConfigurator"/>
                <handler name="RelaySecuirtyMessageBuilderDispatchandler"
                         class="org.apache.synapse.transport.passthru.util.RelaySecuirtyMessageBuilderDispatchandler"/>
                <handler name="SOAPActionBasedDispatcher"
                         class="org.apache.axis2.dispatchers.SOAPActionBasedDispatcher">
                    <order phase="Transport"/>
                </handler>
            </phase>
            <phase name="Addressing">
                <handler name="AddressingBasedDispatcher"
                         class="org.apache.axis2.dispatchers.AddressingBasedDispatcher">
                    <order phase="Addressing"/>
                </handler>
            </phase>
            <phase name="Security"/>
            <phase name="PreDispatch">
            </phase>
            <phase name="Dispatch" class="org.apache.axis2.engine.DispatchPhase">
                <handler name="IntegratorStatefulHandler" class="org.wso2.carbon.integrator.core.handler.IntegratorStatefulHandler"/>
                <handler name="JSONMessageHandler" class="org.apache.axis2.json.gson.JSONMessageHandler" />
                <handler name="SOAPActionBasedDispatcher"
                         class="org.apache.axis2.dispatchers.SOAPActionBasedDispatcher"/>
                <handler name="RequestURIOperationDispatcher"
                         class="org.apache.axis2.dispatchers.RequestURIOperationDispatcher"/>
                <handler name="SOAPMessageBodyBasedDispatcher"
                         class="org.apache.axis2.dispatchers.SOAPMessageBodyBasedDispatcher"/>
                <handler name="HTTPLocationBasedDispatcher"
                         class="org.apache.axis2.dispatchers.HTTPLocationBasedDispatcher"/>
                <handler name="MultitenantDispatcher"
                         class="org.wso2.carbon.tenant.dispatcher.MultitenantDispatcher"/>
                <handler name="SynapseDispatcher"
                         class="org.apache.synapse.core.axis2.SynapseDispatcher"/>
                <handler name="SynapseMustUnderstandHandler"
                         class="org.apache.synapse.core.axis2.SynapseMustUnderstandHandler"/>
            </phase>
            <phase name="RMPhase"/>
            <phase name="OpPhase"/>
            <phase name="AuthPhase"/>
            <phase name="MUPhase"/>
            <phase name="OperationInPhase"/>
        </phaseOrder>
        <phaseOrder type="OutFlow">
            <phase name="UEPPhase" />
            <phase name="RMPhase"/>
            <phase name="MUPhase"/>
            <phase name="OpPhase"/>
            <phase name="OperationOutPhase"/>
            <phase name="PolicyDetermination"/>
            <phase name="PTSecurityOutPhase">
    		<handler name="RelaySecuirtyMessageBuilderDispatchandler"
                         class="org.apache.synapse.transport.passthru.util.RelaySecuirtyMessageBuilderDispatchandler"/>
    	    </phase>
            <phase name="MessageOut"/>
            <phase name="Security"/>
            <phase name="MsgOutObservation"/>
        </phaseOrder>
        <phaseOrder type="InFaultFlow">
            <phase name="MsgInObservation"/>
            <phase name="Validation"/>
            <phase name="Transport">
                <handler name="IntegratorStatefulHandler" class="org.wso2.carbon.integrator.core.handler.IntegratorStatefulHandler">
                    <order phase="Transport"/>
                    <handler name="JSONMessageHandler"
                             class="org.apache.axis2.json.gson.JSONMessageHandler" />
                </handler>
                <handler name="SOAPActionBasedDispatcher"
                         class="org.apache.axis2.dispatchers.SOAPActionBasedDispatcher">
                    <order phase="Transport"/>
                </handler>
            </phase>
            <phase name="Addressing">
                <handler name="AddressingBasedDispatcher"
                         class="org.apache.axis2.dispatchers.AddressingBasedDispatcher">
                    <order phase="Addressing"/>
                </handler>
            </phase>
            <phase name="Security"/>
            <phase name="PreDispatch"/>
            <phase name="Dispatch" class="org.apache.axis2.engine.DispatchPhase">
                <handler name="IntegratorStatefulHandler" class="org.wso2.carbon.integrator.core.handler.IntegratorStatefulHandler"/>
                <handler name="SOAPActionBasedDispatcher"
                         class="org.apache.axis2.dispatchers.SOAPActionBasedDispatcher"/>
                <handler name="RequestURIOperationDispatcher"
                         class="org.apache.axis2.dispatchers.RequestURIOperationDispatcher"/>
                <handler name="SOAPMessageBodyBasedDispatcher"
                         class="org.apache.axis2.dispatchers.SOAPMessageBodyBasedDispatcher"/>
                <handler name="HTTPLocationBasedDispatcher"
                         class="org.apache.axis2.dispatchers.HTTPLocationBasedDispatcher"/>
            </phase>
            <phase name="RMPhase"/>
            <phase name="OpPhase"/>
            <phase name="MUPhase"/>
            <phase name="OperationInFaultPhase"/>
        </phaseOrder>
        <phaseOrder type="OutFaultFlow">
            <phase name="UEPPhase" />
            <phase name="RMPhase"/>
            <phase name="MUPhase"/>
            <phase name="OperationOutFaultPhase"/>
            <phase name="PolicyDetermination"/>
            <phase name="MessageOut"/>
            <phase name="Security"/>
    	<phase name="Transport"/>
            <phase name="MsgOutObservation"/>
        </phaseOrder>
    </axisconfig>
kind: ConfigMap
metadata:
  name: integrator-conf-axis2
  namespace: "$ns.k8s&wso2.ei"
---

apiVersion: v1
data:
  master-datasources.xml: |
    <datasources-configuration xmlns:svns="http://org.wso2.securevault/configuration">
        <providers>
            <provider>org.wso2.carbon.ndatasource.rdbms.RDBMSDataSourceReader</provider>
        </providers>
        <datasources>
            <datasource>
                <name>WSO2_CARBON_DB</name>
                <description>The datasource used for registry and user manager</description>
                <jndiConfig>
                    <name>jdbc/WSO2CarbonDB</name>
                </jndiConfig>
                <definition type="RDBMS">
                    <configuration>
                        <url>jdbc:h2:./repository/database/WSO2CARBON_DB;DB_CLOSE_ON_EXIT=FALSE;LOCK_TIMEOUT=60000</url>
                        <username>wso2carbon</username>
                        <password>wso2carbon</password>
                        <driverClassName>org.h2.Driver</driverClassName>
                        <maxActive>50</maxActive>
                        <maxWait>60000</maxWait>
                        <testOnBorrow>true</testOnBorrow>
                        <validationQuery>SELECT 1</validationQuery>
                        <validationInterval>30000</validationInterval>
                        <defaultAutoCommit>false</defaultAutoCommit>
                    </configuration>
                </definition>
            </datasource>
            <datasource>
                <name>WSO2_CONFIG_DB</name>
                <description>The datasource used for config registry</description>
                <jndiConfig>
                    <name>jdbc/WSO2ConfigDB</name>
                </jndiConfig>
                <definition type="RDBMS">
                    <configuration>
                        <url>jdbc:mysql://wso2ei-integrator-with-analytics-rdbms-service:3306/WSO2EI_INTEGRATOR_CONFIG_GOV_DB?autoReconnect=true&amp;useSSL=false</url>
                        <username>wso2carbon</username>
                        <password>wso2carbon</password>
                        <driverClassName>com.mysql.jdbc.Driver</driverClassName>
                        <maxActive>80</maxActive>
                        <maxWait>60000</maxWait>
                        <testOnBorrow>true</testOnBorrow>
                        <validationQuery>SELECT 1</validationQuery>
                        <validationInterval>30000</validationInterval>
                    </configuration>
                </definition>
            </datasource>
            <datasource>
                <name>WSO2_USER_DB</name>
                <description>The datasource is used for user mangement and userstore</description>
                <jndiConfig>
                    <name>jdbc/WSO2UserDB</name>
                </jndiConfig>
                <definition type="RDBMS">
                    <configuration>
                        <url>jdbc:mysql://wso2ei-integrator-with-analytics-rdbms-service:3306/WSO2EI_USER_DB?autoReconnect=true&amp;useSSL=false</url>
                        <username>wso2carbon</username>
                        <password>wso2carbon</password>
                        <driverClassName>com.mysql.jdbc.Driver</driverClassName>
                        <maxActive>50</maxActive>
                        <maxWait>60000</maxWait>
                        <testOnBorrow>true</testOnBorrow>
                        <validationQuery>SELECT 1</validationQuery>
                        <validationInterval>30000</validationInterval>
                    </configuration>
                </definition>
            </datasource>
        </datasources>
    </datasources-configuration>
kind: ConfigMap
metadata:
  name: integrator-conf-datasources
  namespace: "$ns.k8s&wso2.ei"
---

apiVersion: v1
data:
  deployment.yaml: |
    wso2.carbon:
        # value to uniquely identify a server
      id: wso2-sp
        # server name
      name: WSO2 Stream Processor
        # ports used by this server
      ports:
          # port offset
        offset: 0
      type: wso2-ei-analytics

    wso2.transport.http:
      transportProperties:
        -
          name: "server.bootstrap.socket.timeout"
          value: 60
        -
          name: "client.bootstrap.socket.timeout"
          value: 60
        -
          name: "latency.metrics.enabled"
          value: true

      listenerConfigurations:
        -
          id: "default"
          host: "0.0.0.0"
          port: 9091
        -
          id: "msf4j-https"
          host: "0.0.0.0"
          port: 9444
          scheme: https
          keyStoreFile: "${carbon.home}/resources/security/wso2carbon.jks"
          keyStorePassword: wso2carbon
          certPass: wso2carbon

      senderConfigurations:
        -
          id: "http-sender"

    siddhi.stores.query.api:
      transportProperties:
        -
          name: "server.bootstrap.socket.timeout"
          value: 60
        -
          name: "client.bootstrap.socket.timeout"
          value: 60
        -
          name: "latency.metrics.enabled"
          value: true

      listenerConfigurations:
        -
          id: "default"
          host: "0.0.0.0"
          port: 7070
        -
          id: "msf4j-https"
          host: "0.0.0.0"
          port: 7443
          scheme: https
          keyStoreFile: "${carbon.home}/resources/security/wso2carbon.jks"
          keyStorePassword: wso2carbon
          certPass: wso2carbon

      # Configuration used for the databridge communication
    databridge.config:
        # No of worker threads to consume events
        # THIS IS A MANDATORY FIELD
      workerThreads: 10
        # Maximum amount of messages that can be queued internally in MB
        # THIS IS A MANDATORY FIELD
      maxEventBufferCapacity: 10000000
        # Queue size; the maximum number of events that can be stored in the queue
        # THIS IS A MANDATORY FIELD
      eventBufferSize: 2000
        # Keystore file path
        # THIS IS A MANDATORY FIELD
      keyStoreLocation : ${sys:carbon.home}/resources/security/wso2carbon.jks
        # Keystore password
        # THIS IS A MANDATORY FIELD
      keyStorePassword : wso2carbon
        # Session Timeout value in mins
        # THIS IS A MANDATORY FIELD
      clientTimeoutMin: 30
        # Data receiver configurations
        # THIS IS A MANDATORY FIELD
      dataReceivers:
      -
          # Data receiver configuration
        dataReceiver:
            # Data receiver type
            # THIS IS A MANDATORY FIELD
          type: Thrift
            # Data receiver properties
          properties:
            tcpPort: '7612'
            sslPort: '7712'

      -
          # Data receiver configuration
        dataReceiver:
            # Data receiver type
            # THIS IS A MANDATORY FIELD
          type: Binary
            # Data receiver properties
          properties:
            tcpPort: '9611'
            sslPort: '9711'
            tcpReceiverThreadPoolSize: '100'
            sslReceiverThreadPoolSize: '100'
            hostName: 0.0.0.0

      # Configuration of the Data Agents - to publish events through databridge
    data.agent.config:
        # Data agent configurations
        # THIS IS A MANDATORY FIELD
      agents:
      -
          # Data agent configuration
        agentConfiguration:
            # Data agent name
            # THIS IS A MANDATORY FIELD
          name: Thrift
            # Data endpoint class
            # THIS IS A MANDATORY FIELD
          dataEndpointClass: org.wso2.carbon.databridge.agent.endpoint.thrift.ThriftDataEndpoint
            # Data publisher strategy
          publishingStrategy: async
            # Trust store path
          trustStorePath: '${sys:carbon.home}/resources/security/client-truststore.jks'
            # Trust store password
          trustStorePassword: 'wso2carbon'
            # Queue Size
          queueSize: 32768
            # Batch Size
          batchSize: 200
            # Core pool size
          corePoolSize: 1
            # Socket timeout in milliseconds
          socketTimeoutMS: 30000
            # Maximum pool size
          maxPoolSize: 1
            # Keep alive time in pool
          keepAliveTimeInPool: 20
            # Reconnection interval
          reconnectionInterval: 30
            # Max transport pool size
          maxTransportPoolSize: 250
            # Max idle connections
          maxIdleConnections: 250
            # Eviction time interval
          evictionTimePeriod: 5500
            # Min idle time in pool
          minIdleTimeInPool: 5000
            # Secure max transport pool size
          secureMaxTransportPoolSize: 250
            # Secure max idle connections
          secureMaxIdleConnections: 250
            # secure eviction time period
          secureEvictionTimePeriod: 5500
            # Secure min idle time in pool
          secureMinIdleTimeInPool: 5000
            # SSL enabled protocols
          sslEnabledProtocols: TLSv1.1,TLSv1.2
            # Ciphers
          ciphers: TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256,TLS_DHE_RSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA,TLS_DHE_RSA_WITH_AES_128_CBC_SHA,TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_DHE_RSA_WITH_AES_128_GCM_SHA256
      -
          # Data agent configuration
        agentConfiguration:
            # Data agent name
            # THIS IS A MANDATORY FIELD
          name: Binary
            # Data endpoint class
            # THIS IS A MANDATORY FIELD
          dataEndpointClass: org.wso2.carbon.databridge.agent.endpoint.binary.BinaryDataEndpoint
            # Data publisher strategy
          publishingStrategy: async
            # Trust store path
          trustStorePath: '${sys:carbon.home}/resources/security/client-truststore.jks'
            # Trust store password
          trustStorePassword: 'wso2carbon'
            # Queue Size
          queueSize: 32768
            # Batch Size
          batchSize: 200
            # Core pool size
          corePoolSize: 1
            # Socket timeout in milliseconds
          socketTimeoutMS: 30000
            # Maximum pool size
          maxPoolSize: 1
            # Keep alive time in pool
          keepAliveTimeInPool: 20
            # Reconnection interval
          reconnectionInterval: 30
            # Max transport pool size
          maxTransportPoolSize: 250
            # Max idle connections
          maxIdleConnections: 250
            # Eviction time interval
          evictionTimePeriod: 5500
            # Min idle time in pool
          minIdleTimeInPool: 5000
            # Secure max transport pool size
          secureMaxTransportPoolSize: 250
            # Secure max idle connections
          secureMaxIdleConnections: 250
            # secure eviction time period
          secureEvictionTimePeriod: 5500
            # Secure min idle time in pool
          secureMinIdleTimeInPool: 5000
            # SSL enabled protocols
          sslEnabledProtocols: TLSv1.1,TLSv1.2
            # Ciphers
          ciphers: TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256,TLS_DHE_RSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA,TLS_DHE_RSA_WITH_AES_128_CBC_SHA,TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_DHE_RSA_WITH_AES_128_GCM_SHA256

    # This is the main configuration for metrics
    wso2.metrics:
      # Enable Metrics
      enabled: false
      reporting:
        console:
          - # The name for the Console Reporter
            name: Console

            # Enable Console Reporter
            enabled: false

            # Polling Period in seconds.
            # This is the period for polling metrics from the metric registry and printing in the console
            pollingPeriod: 5

    wso2.metrics.jdbc:
      # Data Source Configurations for JDBC Reporters
      dataSource:
        # Default Data Source Configuration
        - &JDBC01
          # JNDI name of the data source to be used by the JDBC Reporter.
          # This data source should be defined in a *-datasources.xml file in conf/datasources directory.
          dataSourceName: java:comp/env/jdbc/WSO2MetricsDB
          # Schedule regular deletion of metrics data older than a set number of days.
          # It is recommended that you enable this job to ensure your metrics tables do not get extremely large.
          # Deleting data older than seven days should be sufficient.
          scheduledCleanup:
            # Enable scheduled cleanup to delete Metrics data in the database.
            enabled: true

            # The scheduled job will cleanup all data older than the specified days
            daysToKeep: 3

            # This is the period for each cleanup operation in seconds.
            scheduledCleanupPeriod: 86400

      # The JDBC Reporter is in the Metrics JDBC Core feature
      reporting:
        # The JDBC Reporter configurations will be ignored if the Metrics JDBC Core feature is not available in runtime
        jdbc:
          - # The name for the JDBC Reporter
            name: JDBC

            # Enable JDBC Reporter
            enabled: true

            # Source of Metrics, which will be used to identify each metric in database -->
            # Commented to use the hostname by default
            # source: Carbon

            # Alias referring to the Data Source configuration
            dataSource: *JDBC01

            # Polling Period in seconds.
            # This is the period for polling metrics from the metric registry and updating the database with the values
            pollingPeriod: 60

      # Deployment configuration parameters
    wso2.artifact.deployment:
        # Scheduler update interval
      updateInterval: 5

      # Periodic Persistence Configuration
    state.persistence:
      enabled: true
      intervalInMin: 1
      revisionsToKeep: 2
      persistenceStore: org.wso2.carbon.stream.processor.core.persistence.DBPersistenceStore
      config:
        datasource: WSO2_PERSISTENCE_DB
        table: PERSISTENCE_TABLE

      # Secure Vault Configuration
    wso2.securevault:
      secretRepository:
        type: org.wso2.carbon.secvault.repository.DefaultSecretRepository
        parameters:
          privateKeyAlias: wso2carbon
          keystoreLocation: ${sys:carbon.home}/resources/security/securevault.jks
          secretPropertiesFile: ${sys:carbon.home}/conf/${sys:wso2.runtime}/secrets.properties
      masterKeyReader:
        type: org.wso2.carbon.secvault.reader.DefaultMasterKeyReader
        parameters:
          masterKeyReaderFile: ${sys:carbon.home}/conf/${sys:wso2.runtime}/master-keys.yaml

      # Datasource Configurations
    wso2.datasources:
      dataSources:
        - name: WSO2_CLUSTER_DB
          description: "The datasource used by cluster coordinators in HA deployment"
          definition:
            type: RDBMS
            configuration:
              connectionTestQuery: "SELECT 1"
              driverClassName: com.mysql.jdbc.Driver
              idleTimeout: 60000
              isAutoCommit: false
              jdbcUrl: jdbc:mysql://wso2ei-integrator-with-analytics-rdbms-service:3306/WSO2_CLUSTER_DB?useSSL=false
              maxPoolSize: 10
              password: wso2carbon
              username: wso2carbon
              validationTimeout: 30000

        # carbon metrics data source
        - name: WSO2_METRICS_DB
          description: The datasource used for dashboard feature
          jndiConfig:
            name: jdbc/WSO2MetricsDB
          definition:
            type: RDBMS
            configuration:
              jdbcUrl: 'jdbc:h2:${sys:carbon.home}/wso2/dashboard/database/metrics;AUTO_SERVER=TRUE'
              username: wso2carbon
              password: wso2carbon
              driverClassName: org.h2.Driver
              maxPoolSize: 30
              idleTimeout: 60000
              connectionTestQuery: SELECT 1
              validationTimeout: 30000
              isAutoCommit: false

        - name: WSO2_PERMISSIONS_DB
          description: The datasource used for permission feature
          jndiConfig:
            name: jdbc/PERMISSION_DB
            useJndiReference: true
          definition:
            type: RDBMS
            configuration:
              jdbcUrl: 'jdbc:h2:${sys:carbon.home}/wso2/${sys:wso2.runtime}/database/PERMISSION_DB;IFEXISTS=TRUE;DB_CLOSE_ON_EXIT=FALSE;LOCK_TIMEOUT=60000;MVCC=TRUE'
              username: wso2carbon
              password: wso2carbon
              driverClassName: org.h2.Driver
              maxPoolSize: 10
              idleTimeout: 60000
              connectionTestQuery: SELECT 1
              validationTimeout: 30000
              isAutoCommit: false

        - name: EI_ANALYTICS
          description: "The datasource used for EI Analytics dashboard feature"
          jndiConfig:
            name: jdbc/EI_ANALYTICS
          definition:
            type: RDBMS
            configuration:
              jdbcUrl: 'jdbc:mysql://wso2ei-integrator-with-analytics-rdbms-service:3306/EI_ANALYTICS?useSSL=false'
              username: wso2carbon
              password: wso2carbon
              driverClassName: com.mysql.jdbc.Driver
              maxPoolSize: 50
              idleTimeout: 60000
              validationTimeout: 30000
              isAutoCommit: false
          definition:
             configuration:
               username: wso2carbon
               driverClassName: com.mysql.jdbc.Driver
               validationTimeout: 30000
               connectionTestQuery: SELECT 1
               idleTimeout: 60000
               isAutoCommit: false
               maxPoolSize: 50
               password: wso2carbon
               jdbcUrl: jdbc:mysql://wso2ei-integrator-with-analytics-rdbms-service:3306/WSO2_PERSISTENCE_DB?useSSL=false
             type: RDBMS
           name: WSO2_PERSISTENCE_DB
           jndiConfig:
             name: jdbc/WSO2PersistenceDB
           description: The MySQL datasource used for system persistence


    siddhi:
      extensions:
        -
          extension:
            name: 'findCountryFromIP'
            namespace: 'geo'
            properties:
              geoLocationResolverClass: org.wso2.extension.siddhi.execution.geo.internal.impl.DefaultDBBasedGeoLocationResolver
              isCacheEnabled: true
              cacheSize: 10000
              isPersistInDatabase: true
              datasource: GEO_LOCATION_DATA
        -
          extension:
            name: 'findCityFromIP'
            namespace: 'geo'
            properties:
              geoLocationResolverClass: org.wso2.extension.siddhi.execution.geo.internal.impl.DefaultDBBasedGeoLocationResolver
              isCacheEnabled: true
              cacheSize: 10000
              isPersistInDatabase: true
              datasource: GEO_LOCATION_DATA

      # Cluster Configuration
    cluster.config:
      enabled: false
      groupId:  sp
      coordinationStrategyClass: org.wso2.carbon.cluster.coordinator.rdbms.RDBMSCoordinationStrategy
      strategyConfig:
        datasource: WSO2_CLUSTER_DB
        heartbeatInterval: 1000
        heartbeatMaxRetry: 2
        eventPollingInterval: 1000

    # Authentication configuration
    auth.configs:
      type: 'local'        # Type of the IdP client used
      userManager:
        adminRole: admin   # Admin role which is granted all permissions
        userStore:         # User store
          users:
           -
             user:
               username: admin
               password: YWRtaW4=
               roles: 1
          roles:
           -
             role:
               id: 1
               displayName: admin
kind: ConfigMap
metadata:
  name: ei-analytics-conf-worker
  namespace: "$ns.k8s&wso2.ei"
---

apiVersion: v1
data:
  deployment.yaml: |
    wso2.carbon:
        # value to uniquely identify a server
      id: wso2-sp
        # server name
      name: WSO2 Stream Processor
        # ports used by this server
      ports:
          # port offset
        offset: 2

      # Configuration used for the databridge communication
    databridge.config:
        # No of worker threads to consume events
        # THIS IS A MANDATORY FIELD
      workerThreads: 10
        # Maximum amount of messages that can be queued internally in MB
        # THIS IS A MANDATORY FIELD
      maxEventBufferCapacity: 10000000
        # Queue size; the maximum number of events that can be stored in the queue
        # THIS IS A MANDATORY FIELD
      eventBufferSize: 2000
        # Keystore file path
        # THIS IS A MANDATORY FIELD
      keyStoreLocation : ${sys:carbon.home}/resources/security/wso2carbon.jks
        # Keystore password
        # THIS IS A MANDATORY FIELD
      keyStorePassword : wso2carbon
        # Session Timeout value in mins
        # THIS IS A MANDATORY FIELD
      clientTimeoutMin: 30
        # Data receiver configurations
        # THIS IS A MANDATORY FIELD
      dataReceivers:
      -
          # Data receiver configuration
        dataReceiver:
            # Data receiver type
            # THIS IS A MANDATORY FIELD
          type: Thrift
            # Data receiver properties
          properties:
            tcpPort: '7611'
            sslPort: '7711'

      -
          # Data receiver configuration
        dataReceiver:
            # Data receiver type
            # THIS IS A MANDATORY FIELD
          type: Binary
            # Data receiver properties
          properties:
            tcpPort: '9611'
            sslPort: '9711'
            tcpReceiverThreadPoolSize: '100'
            sslReceiverThreadPoolSize: '100'
            hostName: 0.0.0.0

      # Configuration of the Data Agents - to publish events through databridge
    data.agent.config:
        # Data agent configurations
        # THIS IS A MANDATORY FIELD
      agents:
      -
          # Data agent configuration
        agentConfiguration:
            # Data agent name
            # THIS IS A MANDATORY FIELD
          name: Thrift
            # Data endpoint class
            # THIS IS A MANDATORY FIELD
          dataEndpointClass: org.wso2.carbon.databridge.agent.endpoint.thrift.ThriftDataEndpoint
            # Data publisher strategy
          publishingStrategy: async
            # Trust store path
          trustStorePath: '${sys:carbon.home}/resources/security/client-truststore.jks'
            # Trust store password
          trustStorePassword: 'wso2carbon'
            # Queue Size
          queueSize: 32768
            # Batch Size
          batchSize: 200
            # Core pool size
          corePoolSize: 1
            # Socket timeout in milliseconds
          socketTimeoutMS: 30000
            # Maximum pool size
          maxPoolSize: 1
            # Keep alive time in pool
          keepAliveTimeInPool: 20
            # Reconnection interval
          reconnectionInterval: 30
            # Max transport pool size
          maxTransportPoolSize: 250
            # Max idle connections
          maxIdleConnections: 250
            # Eviction time interval
          evictionTimePeriod: 5500
            # Min idle time in pool
          minIdleTimeInPool: 5000
            # Secure max transport pool size
          secureMaxTransportPoolSize: 250
            # Secure max idle connections
          secureMaxIdleConnections: 250
            # secure eviction time period
          secureEvictionTimePeriod: 5500
            # Secure min idle time in pool
          secureMinIdleTimeInPool: 5000
            # SSL enabled protocols
          sslEnabledProtocols: TLSv1.1,TLSv1.2
            # Ciphers
          ciphers: TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256,TLS_DHE_RSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA,TLS_DHE_RSA_WITH_AES_128_CBC_SHA,TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_DHE_RSA_WITH_AES_128_GCM_SHA256
      -
          # Data agent configuration
        agentConfiguration:
            # Data agent name
            # THIS IS A MANDATORY FIELD
          name: Binary
            # Data endpoint class
            # THIS IS A MANDATORY FIELD
          dataEndpointClass: org.wso2.carbon.databridge.agent.endpoint.binary.BinaryDataEndpoint
            # Data publisher strategy
          publishingStrategy: async
            # Trust store path
          trustStorePath: '${sys:carbon.home}/resources/security/client-truststore.jks'
            # Trust store password
          trustStorePassword: 'wso2carbon'
            # Queue Size
          queueSize: 32768
            # Batch Size
          batchSize: 200
            # Core pool size
          corePoolSize: 1
            # Socket timeout in milliseconds
          socketTimeoutMS: 30000
            # Maximum pool size
          maxPoolSize: 1
            # Keep alive time in pool
          keepAliveTimeInPool: 20
            # Reconnection interval
          reconnectionInterval: 30
            # Max transport pool size
          maxTransportPoolSize: 250
            # Max idle connections
          maxIdleConnections: 250
            # Eviction time interval
          evictionTimePeriod: 5500
            # Min idle time in pool
          minIdleTimeInPool: 5000
            # Secure max transport pool size
          secureMaxTransportPoolSize: 250
            # Secure max idle connections
          secureMaxIdleConnections: 250
            # secure eviction time period
          secureEvictionTimePeriod: 5500
            # Secure min idle time in pool
          secureMinIdleTimeInPool: 5000
            # SSL enabled protocols
          sslEnabledProtocols: TLSv1.1,TLSv1.2
            # Ciphers
          ciphers: TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256,TLS_DHE_RSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA,TLS_DHE_RSA_WITH_AES_128_CBC_SHA,TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_DHE_RSA_WITH_AES_128_GCM_SHA256

      # Deployment configuration parameters
    wso2.artifact.deployment:
        # Scheduler update interval
      updateInterval: 5

      # HA Configuration
    state.persistence:
      enabled: false
      intervalInMin: 1
      revisionsToKeep: 2
      persistenceStore: org.wso2.carbon.stream.processor.core.persistence.FileSystemPersistenceStore
      config:
        location: siddhi-app-persistence

      # Secure Vault Configuration
    wso2.securevault:
      secretRepository:
        type: org.wso2.carbon.secvault.repository.DefaultSecretRepository
        parameters:
          privateKeyAlias: wso2carbon
          keystoreLocation: ${sys:carbon.home}/resources/security/securevault.jks
          secretPropertiesFile: ${sys:carbon.home}/conf/${sys:wso2.runtime}/secrets.properties
      masterKeyReader:
        type: org.wso2.carbon.secvault.reader.DefaultMasterKeyReader
        parameters:
          masterKeyReaderFile: ${sys:carbon.home}/conf/${sys:wso2.runtime}/master-keys.yaml


    # Data Sources Configuration
    wso2.datasources:
      dataSources:
      # Dashboard data source
      - name: WSO2_DASHBOARD_DB
        description: The datasource used for dashboard feature
        jndiConfig:
          name: jdbc/DASHBOARD_DB
          useJndiReference: true
        definition:
          type: RDBMS
          configuration:
            jdbcUrl: 'jdbc:h2:${sys:carbon.home}/wso2/${sys:wso2.runtime}/database/DASHBOARD_DB;IFEXISTS=TRUE;DB_CLOSE_ON_EXIT=FALSE;LOCK_TIMEOUT=60000;MVCC=TRUE'
            username: wso2carbon
            password: wso2carbon
            driverClassName: org.h2.Driver
            maxPoolSize: 20
            idleTimeout: 60000
            connectionTestQuery: SELECT 1
            validationTimeout: 30000
            isAutoCommit: false
      - name: BUSINESS_RULES_DB
        description: The datasource used for dashboard feature
        jndiConfig:
          name: jdbc/BUSINESS_RULES_DB
          useJndiReference: true
        definition:
          type: RDBMS
          configuration:
            jdbcUrl: 'jdbc:h2:${sys:carbon.home}/wso2/${sys:wso2.runtime}/database/BUSINESS_RULES_DB;DB_CLOSE_ON_EXIT=FALSE;LOCK_TIMEOUT=60000;MVCC=TRUE'
            username: wso2carbon
            password: wso2carbon
            driverClassName: org.h2.Driver
            maxPoolSize: 20
            idleTimeout: 60000
            connectionTestQuery: SELECT 1
            validationTimeout: 30000
            isAutoCommit: false

      # Dashboard data source
      - name: WSO2_STATUS_DASHBOARD_DB
        description: The datasource used for dashboard feature
        jndiConfig:
          name: jdbc/wso2_status_dashboard
          useJndiReference: true
        definition:
          type: RDBMS
          configuration:
            jdbcUrl: 'jdbc:h2:${sys:carbon.home}/wso2/${sys:wso2.runtime}/database/wso2_status_dashboard;DB_CLOSE_ON_EXIT=FALSE;LOCK_TIMEOUT=60000;MVCC=TRUE'
            username: wso2carbon
            password: wso2carbon
            driverClassName: org.h2.Driver
            maxPoolSize: 20
            idleTimeout: 60000
            connectionTestQuery: SELECT 1
            validationTimeout: 30000
            isAutoCommit: false

      # carbon metrics data source
      - name: WSO2_METRICS_DB
        description: The datasource used for dashboard feature
        jndiConfig:
          name: jdbc/WSO2MetricsDB
        definition:
          type: RDBMS
          configuration:
            jdbcUrl: 'jdbc:h2:${sys:carbon.home}/wso2/dashboard/database/metrics;AUTO_SERVER=TRUE'
            username: wso2carbon
            password: wso2carbon
            driverClassName: org.h2.Driver
            maxPoolSize: 20
            idleTimeout: 60000
            connectionTestQuery: SELECT 1
            validationTimeout: 30000
            isAutoCommit: false

      - name: WSO2_PERMISSIONS_DB
        description: The datasource used for dashboard feature
        jndiConfig:
          name: jdbc/PERMISSION_DB
          useJndiReference: true
        definition:
          type: RDBMS
          configuration:
            jdbcUrl: 'jdbc:h2:${sys:carbon.home}/wso2/${sys:wso2.runtime}/database/PERMISSION_DB;IFEXISTS=TRUE;DB_CLOSE_ON_EXIT=FALSE;LOCK_TIMEOUT=60000;MVCC=TRUE'
            username: wso2carbon
            password: wso2carbon
            driverClassName: org.h2.Driver
            maxPoolSize: 10
            idleTimeout: 60000
            connectionTestQuery: SELECT 1
            validationTimeout: 30000
            isAutoCommit: false

      - name: EI_ANALYTICS
        description: "The datasource used for EI Analytics dashboard feature"
        jndiConfig:
          name: jdbc/EI_ANALYTICS
        definition:
          type: RDBMS
          configuration:
            jdbcUrl: 'jdbc:mysql://wso2ei-integrator-with-analytics-rdbms-service:3306/EI_ANALYTICS?useSSL=false'
            username: wso2carbon
            password: wso2carbon
            driverClassName: com.mysql.jdbc.Driver
            maxPoolSize: 50
            idleTimeout: 60000
            connectionTestQuery: SELECT 1
            validationTimeout: 30000
            isAutoCommit: false

    #  - name: SAMPLE_DB
    #    description: Sample datasource used for gadgets generation wizard
    #    jndiConfig:
    #      name: jdbc/SAMPLE_DB
    #      useJndiReference: true
    #    definition:
    #      type: RDBMS
    #      configuration:
    #        jdbcUrl: 'jdbc:h2:${sys:carbon.home}/wso2/${sys:wso2.runtime}/database/SAMPLE_DB;IFEXISTS=TRUE;DB_CLOSE_ON_EXIT=FALSE;LOCK_TIMEOUT=60000;MVCC=TRUE'
    #        username: wso2carbon
    #        password: wso2carbon
    #        driverClassName: org.h2.Driver
    #        maxPoolSize: 10
    #        idleTimeout: 60000
    #        connectionTestQuery: SELECT 1
    #        validationTimeout: 30000
    #        isAutoCommit: false


    wso2.business.rules.manager:
      datasource: BUSINESS_RULES_DB
      # rule template wise configuration for deploying business rules
      deployment_configs:
        -
         # <IP>:<HTTPS Port> of the Worker node
         localhost:9443:
           # UUIDs of rule templates that are needed to be deployed on the node
           - stock-data-analysis
           - stock-exchange-input
           - stock-exchange-output
           - identifying-continuous-production-decrease
           - popular-tweets-analysis
           - http-analytics-processing
           - message-tracing-source-template
           - message-tracing-app-template
      # credentials for worker nodes
      username: admin
      password: admin

    wso2.status.dashboard:
      pollingInterval: 5
      metricsDatasourceName: 'WSO2_METRICS_DB'
      dashboardDatasourceName: 'WSO2_STATUS_DASHBOARD_DB'
      workerAccessCredentials:
        username: 'admin'
        password: 'admin'

    wso2.transport.http:
      transportProperties:
        - name: "server.bootstrap.socket.timeout"
          value: 60
        - name: "client.bootstrap.socket.timeout"
          value: 60
        - name: "latency.metrics.enabled"
          value: true

      listenerConfigurations:
        - id: "default-https"
          host: "0.0.0.0"
          port: 9643
          scheme: https
          keyStoreFile: "${carbon.home}/resources/security/wso2carbon.jks"
          keyStorePassword: wso2carbon
          certPass: wso2carbon

    # Authentication configuration
    auth.configs:
      type: 'local'        # Type of the IdP client used
      userManager:
        adminRole: admin   # Admin role which is granted all permissions
        userStore:         # User store
          users:
           -
             user:
               username: admin
               password: YWRtaW4=
               roles: 1
          roles:
           -
             role:
               id: 1
               displayName: admin
kind: ConfigMap
metadata:
  name: ei-analytics-dashboard-conf-dashboard
  namespace: "$ns.k8s&wso2.ei"
---

apiVersion: v1
data:
  init.sql: |
    DROP DATABASE IF EXISTS WSO2EI_USER_DB;
    DROP DATABASE IF EXISTS WSO2EI_INTEGRATOR_CONFIG_GOV_DB;
    DROP DATABASE IF EXISTS WSO2_CLUSTER_DB;
    DROP DATABASE IF EXISTS EI_ANALYTICS;
    DROP DATABASE IF EXISTS WSO2_CARBON_DB;
    DROP DATABASE IF EXISTS WSO2_PERSISTENCE_DB;
    CREATE DATABASE WSO2EI_USER_DB;
    CREATE DATABASE WSO2EI_INTEGRATOR_CONFIG_GOV_DB;
    CREATE DATABASE WSO2_CLUSTER_DB;
    CREATE DATABASE EI_ANALYTICS;
    CREATE DATABASE WSO2_CARBON_DB;
    CREATE DATABASE WSO2_PERSISTENCE_DB;
    CREATE USER IF NOT EXISTS 'wso2carbon'@'%' IDENTIFIED BY 'wso2carbon';
    GRANT ALL ON WSO2EI_USER_DB.* TO 'wso2carbon'@'%' IDENTIFIED BY 'wso2carbon';
    GRANT ALL ON WSO2EI_INTEGRATOR_CONFIG_GOV_DB.* TO 'wso2carbon'@'%' IDENTIFIED BY 'wso2carbon';
    GRANT ALL ON WSO2_CLUSTER_DB.* TO 'wso2carbon'@'%' IDENTIFIED BY 'wso2carbon';
    GRANT ALL ON EI_ANALYTICS.* TO 'wso2carbon'@'%' IDENTIFIED BY 'wso2carbon';
    GRANT ALL ON WSO2_CARBON_DB.* TO 'wso2carbon'@'%' IDENTIFIED BY 'wso2carbon';
    GRANT ALL ON WSO2_PERSISTENCE_DB.* TO 'wso2carbon'@'%' IDENTIFIED BY 'wso2carbon';
    USE WSO2EI_USER_DB;
    CREATE TABLE UM_TENANT (
    			UM_ID INTEGER NOT NULL AUTO_INCREMENT,
    	        UM_DOMAIN_NAME VARCHAR(255) NOT NULL,
                UM_EMAIL VARCHAR(255),
                UM_ACTIVE BOOLEAN DEFAULT FALSE,
    	        UM_CREATED_DATE TIMESTAMP NOT NULL,
    	        UM_USER_CONFIG LONGBLOB,
    			PRIMARY KEY (UM_ID),
    			UNIQUE(UM_DOMAIN_NAME)
    )ENGINE INNODB;
    CREATE TABLE UM_DOMAIN(
                UM_DOMAIN_ID INTEGER NOT NULL AUTO_INCREMENT,
                UM_DOMAIN_NAME VARCHAR(255),
                UM_TENANT_ID INTEGER DEFAULT 0,
                PRIMARY KEY (UM_DOMAIN_ID, UM_TENANT_ID)
    )ENGINE INNODB;
    CREATE UNIQUE INDEX INDEX_UM_TENANT_UM_DOMAIN_NAME
                        ON UM_TENANT (UM_DOMAIN_NAME);
    CREATE TABLE UM_USER (
                 UM_ID INTEGER NOT NULL AUTO_INCREMENT,
                 UM_USER_NAME VARCHAR(255) NOT NULL,
                 UM_USER_PASSWORD VARCHAR(255) NOT NULL,
                 UM_SALT_VALUE VARCHAR(31),
                 UM_REQUIRE_CHANGE BOOLEAN DEFAULT FALSE,
                 UM_CHANGED_TIME TIMESTAMP NOT NULL,
                 UM_TENANT_ID INTEGER DEFAULT 0,
                 PRIMARY KEY (UM_ID, UM_TENANT_ID),
                 UNIQUE(UM_USER_NAME, UM_TENANT_ID)
    )ENGINE INNODB;
    CREATE TABLE UM_SYSTEM_USER (
                 UM_ID INTEGER NOT NULL AUTO_INCREMENT,
                 UM_USER_NAME VARCHAR(255) NOT NULL,
                 UM_USER_PASSWORD VARCHAR(255) NOT NULL,
                 UM_SALT_VALUE VARCHAR(31),
                 UM_REQUIRE_CHANGE BOOLEAN DEFAULT FALSE,
                 UM_CHANGED_TIME TIMESTAMP NOT NULL,
                 UM_TENANT_ID INTEGER DEFAULT 0,
                 PRIMARY KEY (UM_ID, UM_TENANT_ID),
                 UNIQUE(UM_USER_NAME, UM_TENANT_ID)
    )ENGINE INNODB;
    CREATE TABLE UM_ROLE (
                 UM_ID INTEGER NOT NULL AUTO_INCREMENT,
                 UM_ROLE_NAME VARCHAR(255) NOT NULL,
                 UM_TENANT_ID INTEGER DEFAULT 0,
    		UM_SHARED_ROLE BOOLEAN DEFAULT FALSE,
                 PRIMARY KEY (UM_ID, UM_TENANT_ID),
                 UNIQUE(UM_ROLE_NAME, UM_TENANT_ID)
    )ENGINE INNODB;
    CREATE TABLE UM_MODULE(
    	UM_ID INTEGER  NOT NULL AUTO_INCREMENT,
    	UM_MODULE_NAME VARCHAR(100),
    	UNIQUE(UM_MODULE_NAME),
    	PRIMARY KEY(UM_ID)
    )ENGINE INNODB;
    CREATE TABLE UM_MODULE_ACTIONS(
    	UM_ACTION VARCHAR(255) NOT NULL,
    	UM_MODULE_ID INTEGER NOT NULL,
    	PRIMARY KEY(UM_ACTION, UM_MODULE_ID),
    	FOREIGN KEY (UM_MODULE_ID) REFERENCES UM_MODULE(UM_ID) ON DELETE CASCADE
    )ENGINE INNODB;
    CREATE TABLE UM_PERMISSION (
                 UM_ID INTEGER NOT NULL AUTO_INCREMENT,
                 UM_RESOURCE_ID VARCHAR(255) NOT NULL,
                 UM_ACTION VARCHAR(255) NOT NULL,
                 UM_TENANT_ID INTEGER DEFAULT 0,
    		UM_MODULE_ID INTEGER DEFAULT 0,
    			       UNIQUE(UM_RESOURCE_ID,UM_ACTION, UM_TENANT_ID),
                 PRIMARY KEY (UM_ID, UM_TENANT_ID)
    )ENGINE INNODB;
    CREATE INDEX INDEX_UM_PERMISSION_UM_RESOURCE_ID_UM_ACTION ON UM_PERMISSION (UM_RESOURCE_ID, UM_ACTION, UM_TENANT_ID);
    CREATE TABLE UM_ROLE_PERMISSION (
                 UM_ID INTEGER NOT NULL AUTO_INCREMENT,
                 UM_PERMISSION_ID INTEGER NOT NULL,
                 UM_ROLE_NAME VARCHAR(255) NOT NULL,
                 UM_IS_ALLOWED SMALLINT NOT NULL,
                 UM_TENANT_ID INTEGER DEFAULT 0,
    	     UM_DOMAIN_ID INTEGER,
                 UNIQUE (UM_PERMISSION_ID, UM_ROLE_NAME, UM_TENANT_ID, UM_DOMAIN_ID),
    	     FOREIGN KEY (UM_PERMISSION_ID, UM_TENANT_ID) REFERENCES UM_PERMISSION(UM_ID, UM_TENANT_ID) ON DELETE CASCADE,
    	     FOREIGN KEY (UM_DOMAIN_ID, UM_TENANT_ID) REFERENCES UM_DOMAIN(UM_DOMAIN_ID, UM_TENANT_ID) ON DELETE CASCADE,
                 PRIMARY KEY (UM_ID, UM_TENANT_ID)
    )ENGINE INNODB;
    -- REMOVED UNIQUE (UM_PERMISSION_ID, UM_ROLE_ID)
    CREATE TABLE UM_USER_PERMISSION (
                 UM_ID INTEGER NOT NULL AUTO_INCREMENT,
                 UM_PERMISSION_ID INTEGER NOT NULL,
                 UM_USER_NAME VARCHAR(255) NOT NULL,
                 UM_IS_ALLOWED SMALLINT NOT NULL,
                 UM_TENANT_ID INTEGER DEFAULT 0,
                 FOREIGN KEY (UM_PERMISSION_ID, UM_TENANT_ID) REFERENCES UM_PERMISSION(UM_ID, UM_TENANT_ID) ON DELETE CASCADE,
                 PRIMARY KEY (UM_ID, UM_TENANT_ID)
    )ENGINE INNODB;
    -- REMOVED UNIQUE (UM_PERMISSION_ID, UM_USER_ID)
    CREATE TABLE UM_USER_ROLE (
                 UM_ID INTEGER NOT NULL AUTO_INCREMENT,
                 UM_ROLE_ID INTEGER NOT NULL,
                 UM_USER_ID INTEGER NOT NULL,
                 UM_TENANT_ID INTEGER DEFAULT 0,
                 UNIQUE (UM_USER_ID, UM_ROLE_ID, UM_TENANT_ID),
                 FOREIGN KEY (UM_ROLE_ID, UM_TENANT_ID) REFERENCES UM_ROLE(UM_ID, UM_TENANT_ID),
                 FOREIGN KEY (UM_USER_ID, UM_TENANT_ID) REFERENCES UM_USER(UM_ID, UM_TENANT_ID),
                 PRIMARY KEY (UM_ID, UM_TENANT_ID)
    )ENGINE INNODB;
    CREATE TABLE UM_SHARED_USER_ROLE(
        UM_ROLE_ID INTEGER NOT NULL,
        UM_USER_ID INTEGER NOT NULL,
        UM_USER_TENANT_ID INTEGER NOT NULL,
        UM_ROLE_TENANT_ID INTEGER NOT NULL,
        UNIQUE(UM_USER_ID,UM_ROLE_ID,UM_USER_TENANT_ID, UM_ROLE_TENANT_ID),
        FOREIGN KEY(UM_ROLE_ID,UM_ROLE_TENANT_ID) REFERENCES UM_ROLE(UM_ID,UM_TENANT_ID) ON DELETE CASCADE,
        FOREIGN KEY(UM_USER_ID,UM_USER_TENANT_ID) REFERENCES UM_USER(UM_ID,UM_TENANT_ID) ON DELETE CASCADE
    )ENGINE INNODB;
    CREATE TABLE UM_ACCOUNT_MAPPING(
    	UM_ID INTEGER NOT NULL AUTO_INCREMENT,
    	UM_USER_NAME VARCHAR(255) NOT NULL,
    	UM_TENANT_ID INTEGER NOT NULL,
    	UM_USER_STORE_DOMAIN VARCHAR(100),
    	UM_ACC_LINK_ID INTEGER NOT NULL,
    	UNIQUE(UM_USER_NAME, UM_TENANT_ID, UM_USER_STORE_DOMAIN, UM_ACC_LINK_ID),
    	FOREIGN KEY (UM_TENANT_ID) REFERENCES UM_TENANT(UM_ID) ON DELETE CASCADE,
    	PRIMARY KEY (UM_ID)
    )ENGINE INNODB;
    CREATE TABLE UM_USER_ATTRIBUTE (
                UM_ID INTEGER NOT NULL AUTO_INCREMENT,
                UM_ATTR_NAME VARCHAR(255) NOT NULL,
                UM_ATTR_VALUE VARCHAR(1024),
                UM_PROFILE_ID VARCHAR(255),
                UM_USER_ID INTEGER,
                UM_TENANT_ID INTEGER DEFAULT 0,
                FOREIGN KEY (UM_USER_ID, UM_TENANT_ID) REFERENCES UM_USER(UM_ID, UM_TENANT_ID),
                PRIMARY KEY (UM_ID, UM_TENANT_ID)
    )ENGINE INNODB;
    CREATE INDEX UM_USER_ID_INDEX ON UM_USER_ATTRIBUTE(UM_USER_ID);
    CREATE TABLE UM_DIALECT(
                UM_ID INTEGER NOT NULL AUTO_INCREMENT,
                UM_DIALECT_URI VARCHAR(255) NOT NULL,
                UM_TENANT_ID INTEGER DEFAULT 0,
                UNIQUE(UM_DIALECT_URI, UM_TENANT_ID),
                PRIMARY KEY (UM_ID, UM_TENANT_ID)
    )ENGINE INNODB;
    CREATE TABLE UM_CLAIM(
                UM_ID INTEGER NOT NULL AUTO_INCREMENT,
                UM_DIALECT_ID INTEGER NOT NULL,
                UM_CLAIM_URI VARCHAR(255) NOT NULL,
                UM_DISPLAY_TAG VARCHAR(255),
                UM_DESCRIPTION VARCHAR(255),
                UM_MAPPED_ATTRIBUTE_DOMAIN VARCHAR(255),
                UM_MAPPED_ATTRIBUTE VARCHAR(255),
                UM_REG_EX VARCHAR(255),
                UM_SUPPORTED SMALLINT,
                UM_REQUIRED SMALLINT,
                UM_DISPLAY_ORDER INTEGER,
    	    UM_CHECKED_ATTRIBUTE SMALLINT,
                UM_READ_ONLY SMALLINT,
                UM_TENANT_ID INTEGER DEFAULT 0,
                UNIQUE(UM_DIALECT_ID, UM_CLAIM_URI, UM_TENANT_ID,UM_MAPPED_ATTRIBUTE_DOMAIN),
                FOREIGN KEY(UM_DIALECT_ID, UM_TENANT_ID) REFERENCES UM_DIALECT(UM_ID, UM_TENANT_ID),
                PRIMARY KEY (UM_ID, UM_TENANT_ID)
    )ENGINE INNODB;
    CREATE TABLE UM_PROFILE_CONFIG(
                UM_ID INTEGER NOT NULL AUTO_INCREMENT,
                UM_DIALECT_ID INTEGER NOT NULL,
                UM_PROFILE_NAME VARCHAR(255),
                UM_TENANT_ID INTEGER DEFAULT 0,
                FOREIGN KEY(UM_DIALECT_ID, UM_TENANT_ID) REFERENCES UM_DIALECT(UM_ID, UM_TENANT_ID),
                PRIMARY KEY (UM_ID, UM_TENANT_ID)
    )ENGINE INNODB;
    CREATE TABLE IF NOT EXISTS UM_CLAIM_BEHAVIOR(
        UM_ID INTEGER NOT NULL AUTO_INCREMENT,
        UM_PROFILE_ID INTEGER,
        UM_CLAIM_ID INTEGER,
        UM_BEHAVIOUR SMALLINT,
        UM_TENANT_ID INTEGER DEFAULT 0,
        FOREIGN KEY(UM_PROFILE_ID, UM_TENANT_ID) REFERENCES UM_PROFILE_CONFIG(UM_ID,UM_TENANT_ID),
        FOREIGN KEY(UM_CLAIM_ID, UM_TENANT_ID) REFERENCES UM_CLAIM(UM_ID,UM_TENANT_ID),
        PRIMARY KEY(UM_ID, UM_TENANT_ID)
    )ENGINE INNODB;
    CREATE TABLE UM_HYBRID_ROLE(
                UM_ID INTEGER NOT NULL AUTO_INCREMENT,
                UM_ROLE_NAME VARCHAR(255),
                UM_TENANT_ID INTEGER DEFAULT 0,
                PRIMARY KEY (UM_ID, UM_TENANT_ID)
    )ENGINE INNODB;
    CREATE TABLE UM_HYBRID_USER_ROLE(
                UM_ID INTEGER NOT NULL AUTO_INCREMENT,
                UM_USER_NAME VARCHAR(255),
                UM_ROLE_ID INTEGER NOT NULL,
                UM_TENANT_ID INTEGER DEFAULT 0,
    	    UM_DOMAIN_ID INTEGER,
                UNIQUE (UM_USER_NAME, UM_ROLE_ID, UM_TENANT_ID, UM_DOMAIN_ID),
                FOREIGN KEY (UM_ROLE_ID, UM_TENANT_ID) REFERENCES UM_HYBRID_ROLE(UM_ID, UM_TENANT_ID) ON DELETE CASCADE,
    	    FOREIGN KEY (UM_DOMAIN_ID, UM_TENANT_ID) REFERENCES UM_DOMAIN(UM_DOMAIN_ID, UM_TENANT_ID) ON DELETE CASCADE,
                PRIMARY KEY (UM_ID, UM_TENANT_ID)
    )ENGINE INNODB;
    CREATE TABLE UM_SYSTEM_ROLE(
                UM_ID INTEGER NOT NULL AUTO_INCREMENT,
                UM_ROLE_NAME VARCHAR(255),
                UM_TENANT_ID INTEGER DEFAULT 0,
                PRIMARY KEY (UM_ID, UM_TENANT_ID)
    )ENGINE INNODB;
    CREATE INDEX SYSTEM_ROLE_IND_BY_RN_TI ON UM_SYSTEM_ROLE(UM_ROLE_NAME, UM_TENANT_ID);
    CREATE TABLE UM_SYSTEM_USER_ROLE(
                UM_ID INTEGER NOT NULL AUTO_INCREMENT,
                UM_USER_NAME VARCHAR(255),
                UM_ROLE_ID INTEGER NOT NULL,
                UM_TENANT_ID INTEGER DEFAULT 0,
                UNIQUE (UM_USER_NAME, UM_ROLE_ID, UM_TENANT_ID),
                FOREIGN KEY (UM_ROLE_ID, UM_TENANT_ID) REFERENCES UM_SYSTEM_ROLE(UM_ID, UM_TENANT_ID),
                PRIMARY KEY (UM_ID, UM_TENANT_ID)
    )ENGINE INNODB;
    CREATE TABLE UM_HYBRID_REMEMBER_ME(
                UM_ID INTEGER NOT NULL AUTO_INCREMENT,
    			UM_USER_NAME VARCHAR(255) NOT NULL,
    			UM_COOKIE_VALUE VARCHAR(1024),
    			UM_CREATED_TIME TIMESTAMP,
                UM_TENANT_ID INTEGER DEFAULT 0,
    			PRIMARY KEY (UM_ID, UM_TENANT_ID)
    )ENGINE INNODB;
    USE WSO2EI_INTEGRATOR_CONFIG_GOV_DB;
    CREATE TABLE IF NOT EXISTS REG_CLUSTER_LOCK (
                 REG_LOCK_NAME VARCHAR (20),
                 REG_LOCK_STATUS VARCHAR (20),
                 REG_LOCKED_TIME TIMESTAMP,
                 REG_TENANT_ID INTEGER DEFAULT 0,
                 PRIMARY KEY (REG_LOCK_NAME)
    )ENGINE INNODB;
    CREATE TABLE IF NOT EXISTS REG_LOG (
                 REG_LOG_ID INTEGER AUTO_INCREMENT,
                 REG_PATH VARCHAR (750),
                 REG_USER_ID VARCHAR (31) NOT NULL,
                 REG_LOGGED_TIME TIMESTAMP NOT NULL,
                 REG_ACTION INTEGER NOT NULL,
                 REG_ACTION_DATA VARCHAR (500),
                 REG_TENANT_ID INTEGER DEFAULT 0,
                 PRIMARY KEY (REG_LOG_ID, REG_TENANT_ID)
    )ENGINE INNODB;
    CREATE INDEX REG_LOG_IND_BY_REGLOG USING HASH ON REG_LOG(REG_LOGGED_TIME, REG_TENANT_ID);
    -- The REG_PATH_VALUE should be less than 767 bytes, and hence was fixed at 750.
    -- See CARBON-5917.
    CREATE TABLE IF NOT EXISTS REG_PATH(
                 REG_PATH_ID INTEGER NOT NULL AUTO_INCREMENT,
                 REG_PATH_VALUE VARCHAR(750) NOT NULL,
                 REG_PATH_PARENT_ID INTEGER,
                 REG_TENANT_ID INTEGER DEFAULT 0,
                 CONSTRAINT PK_REG_PATH PRIMARY KEY(REG_PATH_ID, REG_TENANT_ID)
    )ENGINE INNODB;
    CREATE INDEX REG_PATH_IND_BY_PATH_VALUE USING HASH ON REG_PATH(REG_PATH_VALUE, REG_TENANT_ID);
    CREATE INDEX REG_PATH_IND_BY_PATH_PARENT_ID USING HASH ON REG_PATH(REG_PATH_PARENT_ID, REG_TENANT_ID);
    CREATE TABLE IF NOT EXISTS REG_CONTENT (
                 REG_CONTENT_ID INTEGER NOT NULL AUTO_INCREMENT,
                 REG_CONTENT_DATA LONGBLOB,
                 REG_TENANT_ID INTEGER DEFAULT 0,
                 CONSTRAINT PK_REG_CONTENT PRIMARY KEY(REG_CONTENT_ID, REG_TENANT_ID)
    )ENGINE INNODB;
    CREATE TABLE IF NOT EXISTS REG_CONTENT_HISTORY (
                 REG_CONTENT_ID INTEGER NOT NULL,
                 REG_CONTENT_DATA LONGBLOB,
                 REG_DELETED   SMALLINT,
                 REG_TENANT_ID INTEGER DEFAULT 0,
                 CONSTRAINT PK_REG_CONTENT_HISTORY PRIMARY KEY(REG_CONTENT_ID, REG_TENANT_ID)
    )ENGINE INNODB;
    CREATE TABLE IF NOT EXISTS REG_RESOURCE (
                REG_PATH_ID         INTEGER NOT NULL,
                REG_NAME            VARCHAR(256),
                REG_VERSION         INTEGER NOT NULL AUTO_INCREMENT,
                REG_MEDIA_TYPE      VARCHAR(500),
                REG_CREATOR         VARCHAR(31) NOT NULL,
                REG_CREATED_TIME    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                REG_LAST_UPDATOR    VARCHAR(31),
                REG_LAST_UPDATED_TIME    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                REG_DESCRIPTION     VARCHAR(1000),
                REG_CONTENT_ID      INTEGER,
                REG_TENANT_ID INTEGER DEFAULT 0,
                REG_UUID VARCHAR(100) NOT NULL,
                CONSTRAINT PK_REG_RESOURCE PRIMARY KEY(REG_VERSION, REG_TENANT_ID)
    )ENGINE INNODB;
    ALTER TABLE REG_RESOURCE ADD CONSTRAINT REG_RESOURCE_FK_BY_PATH_ID FOREIGN KEY (REG_PATH_ID, REG_TENANT_ID) REFERENCES REG_PATH (REG_PATH_ID, REG_TENANT_ID);
    ALTER TABLE REG_RESOURCE ADD CONSTRAINT REG_RESOURCE_FK_BY_CONTENT_ID FOREIGN KEY (REG_CONTENT_ID, REG_TENANT_ID) REFERENCES REG_CONTENT (REG_CONTENT_ID, REG_TENANT_ID);
    CREATE INDEX REG_RESOURCE_IND_BY_NAME USING HASH ON REG_RESOURCE(REG_NAME, REG_TENANT_ID);
    CREATE INDEX REG_RESOURCE_IND_BY_PATH_ID_NAME USING HASH ON REG_RESOURCE(REG_PATH_ID, REG_NAME, REG_TENANT_ID);
    CREATE INDEX REG_RESOURCE_IND_BY_UUID USING HASH ON REG_RESOURCE(REG_UUID);
    CREATE INDEX REG_RESOURCE_IND_BY_TENAN USING HASH ON REG_RESOURCE(REG_TENANT_ID, REG_UUID);
    CREATE INDEX REG_RESOURCE_IND_BY_TYPE USING HASH ON REG_RESOURCE(REG_TENANT_ID, REG_MEDIA_TYPE);
    CREATE TABLE IF NOT EXISTS REG_RESOURCE_HISTORY (
                REG_PATH_ID         INTEGER NOT NULL,
                REG_NAME            VARCHAR(256),
                REG_VERSION         INTEGER NOT NULL,
                REG_MEDIA_TYPE      VARCHAR(500),
                REG_CREATOR         VARCHAR(31) NOT NULL,
                REG_CREATED_TIME    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                REG_LAST_UPDATOR    VARCHAR(31),
                REG_LAST_UPDATED_TIME    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                REG_DESCRIPTION     VARCHAR(1000),
                REG_CONTENT_ID      INTEGER,
                REG_DELETED         SMALLINT,
                REG_TENANT_ID INTEGER DEFAULT 0,
                REG_UUID VARCHAR(100) NOT NULL,
                CONSTRAINT PK_REG_RESOURCE_HISTORY PRIMARY KEY(REG_VERSION, REG_TENANT_ID)
    )ENGINE INNODB;
    ALTER TABLE REG_RESOURCE_HISTORY ADD CONSTRAINT REG_RESOURCE_HIST_FK_BY_PATHID FOREIGN KEY (REG_PATH_ID, REG_TENANT_ID) REFERENCES REG_PATH (REG_PATH_ID, REG_TENANT_ID);
    ALTER TABLE REG_RESOURCE_HISTORY ADD CONSTRAINT REG_RESOURCE_HIST_FK_BY_CONTENT_ID FOREIGN KEY (REG_CONTENT_ID, REG_TENANT_ID) REFERENCES REG_CONTENT_HISTORY (REG_CONTENT_ID, REG_TENANT_ID);
    CREATE INDEX REG_RESOURCE_HISTORY_IND_BY_NAME USING HASH ON REG_RESOURCE_HISTORY(REG_NAME, REG_TENANT_ID);
    CREATE INDEX REG_RESOURCE_HISTORY_IND_BY_PATH_ID_NAME USING HASH ON REG_RESOURCE(REG_PATH_ID, REG_NAME, REG_TENANT_ID);
    CREATE TABLE IF NOT EXISTS REG_COMMENT (
                REG_ID        INTEGER NOT NULL AUTO_INCREMENT,
                REG_COMMENT_TEXT      VARCHAR(500) NOT NULL,
                REG_USER_ID           VARCHAR(31) NOT NULL,
                REG_COMMENTED_TIME    TIMESTAMP NOT NULL,
                REG_TENANT_ID INTEGER DEFAULT 0,
                CONSTRAINT PK_REG_COMMENT PRIMARY KEY(REG_ID, REG_TENANT_ID)
    )ENGINE INNODB;
    CREATE TABLE IF NOT EXISTS REG_RESOURCE_COMMENT (
                REG_COMMENT_ID          INTEGER NOT NULL,
                REG_VERSION             INTEGER,
                REG_PATH_ID             INTEGER,
                REG_RESOURCE_NAME       VARCHAR(256),
                REG_TENANT_ID INTEGER DEFAULT 0
    )ENGINE INNODB;
    ALTER TABLE REG_RESOURCE_COMMENT ADD CONSTRAINT REG_RESOURCE_COMMENT_FK_BY_PATH_ID FOREIGN KEY (REG_PATH_ID, REG_TENANT_ID) REFERENCES REG_PATH (REG_PATH_ID, REG_TENANT_ID);
    ALTER TABLE REG_RESOURCE_COMMENT ADD CONSTRAINT REG_RESOURCE_COMMENT_FK_BY_COMMENT_ID FOREIGN KEY (REG_COMMENT_ID, REG_TENANT_ID) REFERENCES REG_COMMENT (REG_ID, REG_TENANT_ID);
    CREATE INDEX REG_RESOURCE_COMMENT_IND_BY_PATH_ID_AND_RESOURCE_NAME USING HASH ON REG_RESOURCE_COMMENT(REG_PATH_ID, REG_RESOURCE_NAME, REG_TENANT_ID);
    CREATE INDEX REG_RESOURCE_COMMENT_IND_BY_VERSION USING HASH ON REG_RESOURCE_COMMENT(REG_VERSION, REG_TENANT_ID);
    CREATE TABLE IF NOT EXISTS REG_RATING (
                REG_ID     INTEGER NOT NULL AUTO_INCREMENT,
                REG_RATING        INTEGER NOT NULL,
                REG_USER_ID       VARCHAR(31) NOT NULL,
                REG_RATED_TIME    TIMESTAMP NOT NULL,
                REG_TENANT_ID INTEGER DEFAULT 0,
                CONSTRAINT PK_REG_RATING PRIMARY KEY(REG_ID, REG_TENANT_ID)
    )ENGINE INNODB;
    CREATE TABLE IF NOT EXISTS REG_RESOURCE_RATING (
                REG_RATING_ID           INTEGER NOT NULL,
                REG_VERSION             INTEGER,
                REG_PATH_ID             INTEGER,
                REG_RESOURCE_NAME       VARCHAR(256),
                REG_TENANT_ID INTEGER DEFAULT 0
    )ENGINE INNODB;
    ALTER TABLE REG_RESOURCE_RATING ADD CONSTRAINT REG_RESOURCE_RATING_FK_BY_PATH_ID FOREIGN KEY (REG_PATH_ID, REG_TENANT_ID) REFERENCES REG_PATH (REG_PATH_ID, REG_TENANT_ID);
    ALTER TABLE REG_RESOURCE_RATING ADD CONSTRAINT REG_RESOURCE_RATING_FK_BY_RATING_ID FOREIGN KEY (REG_RATING_ID, REG_TENANT_ID) REFERENCES REG_RATING (REG_ID, REG_TENANT_ID);
    CREATE INDEX REG_RESOURCE_RATING_IND_BY_PATH_ID_AND_RESOURCE_NAME USING HASH ON REG_RESOURCE_RATING(REG_PATH_ID, REG_RESOURCE_NAME, REG_TENANT_ID);
    CREATE INDEX REG_RESOURCE_RATING_IND_BY_VERSION USING HASH ON REG_RESOURCE_RATING(REG_VERSION, REG_TENANT_ID);
    CREATE TABLE IF NOT EXISTS REG_TAG (
                REG_ID         INTEGER NOT NULL AUTO_INCREMENT,
                REG_TAG_NAME       VARCHAR(500) NOT NULL,
                REG_USER_ID        VARCHAR(31) NOT NULL,
                REG_TAGGED_TIME    TIMESTAMP NOT NULL,
                REG_TENANT_ID INTEGER DEFAULT 0,
                CONSTRAINT PK_REG_TAG PRIMARY KEY(REG_ID, REG_TENANT_ID)
    )ENGINE INNODB;
    CREATE TABLE IF NOT EXISTS REG_RESOURCE_TAG (
                REG_TAG_ID              INTEGER NOT NULL,
                REG_VERSION             INTEGER,
                REG_PATH_ID             INTEGER,
                REG_RESOURCE_NAME       VARCHAR(256),
                REG_TENANT_ID INTEGER DEFAULT 0
    )ENGINE INNODB;
    ALTER TABLE REG_RESOURCE_TAG ADD CONSTRAINT REG_RESOURCE_TAG_FK_BY_PATH_ID FOREIGN KEY (REG_PATH_ID, REG_TENANT_ID) REFERENCES REG_PATH (REG_PATH_ID, REG_TENANT_ID);
    ALTER TABLE REG_RESOURCE_TAG ADD CONSTRAINT REG_RESOURCE_TAG_FK_BY_TAG_ID FOREIGN KEY (REG_TAG_ID, REG_TENANT_ID) REFERENCES REG_TAG (REG_ID, REG_TENANT_ID);
    CREATE INDEX REG_RESOURCE_TAG_IND_BY_PATH_ID_AND_RESOURCE_NAME USING HASH ON REG_RESOURCE_TAG(REG_PATH_ID, REG_RESOURCE_NAME, REG_TENANT_ID);
    CREATE INDEX REG_RESOURCE_TAG_IND_BY_VERSION USING HASH ON REG_RESOURCE_TAG(REG_VERSION, REG_TENANT_ID);
    CREATE TABLE IF NOT EXISTS REG_PROPERTY (
                REG_ID         INTEGER NOT NULL AUTO_INCREMENT,
                REG_NAME       VARCHAR(100) NOT NULL,
                REG_VALUE        VARCHAR(1000),
                REG_TENANT_ID INTEGER DEFAULT 0,
                CONSTRAINT PK_REG_PROPERTY PRIMARY KEY(REG_ID, REG_TENANT_ID)
    )ENGINE INNODB;
    CREATE TABLE IF NOT EXISTS REG_RESOURCE_PROPERTY (
                REG_PROPERTY_ID         INTEGER NOT NULL,
                REG_VERSION             INTEGER,
                REG_PATH_ID             INTEGER,
                REG_RESOURCE_NAME       VARCHAR(256),
                REG_TENANT_ID INTEGER DEFAULT 0
    )ENGINE INNODB;
    ALTER TABLE REG_RESOURCE_PROPERTY ADD CONSTRAINT REG_RESOURCE_PROPERTY_FK_BY_PATH_ID FOREIGN KEY (REG_PATH_ID, REG_TENANT_ID) REFERENCES REG_PATH (REG_PATH_ID, REG_TENANT_ID);
    ALTER TABLE REG_RESOURCE_PROPERTY ADD CONSTRAINT REG_RESOURCE_PROPERTY_FK_BY_TAG_ID FOREIGN KEY (REG_PROPERTY_ID, REG_TENANT_ID) REFERENCES REG_PROPERTY (REG_ID, REG_TENANT_ID);
    CREATE INDEX REG_RESOURCE_PROPERTY_IND_BY_PATH_ID_AND_RESOURCE_NAME USING HASH ON REG_RESOURCE_PROPERTY(REG_PATH_ID, REG_RESOURCE_NAME, REG_TENANT_ID);
    CREATE INDEX REG_RESOURCE_PROPERTY_IND_BY_VERSION USING HASH ON REG_RESOURCE_PROPERTY(REG_VERSION, REG_TENANT_ID);
    CREATE TABLE IF NOT EXISTS REG_ASSOCIATION (
                REG_ASSOCIATION_ID INTEGER AUTO_INCREMENT,
                REG_SOURCEPATH VARCHAR (750) NOT NULL,
                REG_TARGETPATH VARCHAR (750) NOT NULL,
                REG_ASSOCIATION_TYPE VARCHAR (2000) NOT NULL,
                REG_TENANT_ID INTEGER DEFAULT 0,
                PRIMARY KEY (REG_ASSOCIATION_ID, REG_TENANT_ID)
    )ENGINE INNODB;
    CREATE TABLE IF NOT EXISTS REG_SNAPSHOT (
                REG_SNAPSHOT_ID     INTEGER NOT NULL AUTO_INCREMENT,
                REG_PATH_ID            INTEGER NOT NULL,
                REG_RESOURCE_NAME      VARCHAR(255),
                REG_RESOURCE_VIDS     LONGBLOB NOT NULL,
                REG_TENANT_ID INTEGER DEFAULT 0,
                CONSTRAINT PK_REG_SNAPSHOT PRIMARY KEY(REG_SNAPSHOT_ID, REG_TENANT_ID)
    )ENGINE INNODB;
    CREATE INDEX REG_SNAPSHOT_IND_BY_PATH_ID_AND_RESOURCE_NAME USING HASH ON REG_SNAPSHOT(REG_PATH_ID, REG_RESOURCE_NAME, REG_TENANT_ID);
    ALTER TABLE REG_SNAPSHOT ADD CONSTRAINT REG_SNAPSHOT_FK_BY_PATH_ID FOREIGN KEY (REG_PATH_ID, REG_TENANT_ID) REFERENCES REG_PATH (REG_PATH_ID, REG_TENANT_ID);
kind: ConfigMap
metadata:
  name: mysql-dbscripts
  namespace: "$ns.k8s&wso2.ei"
---

apiVersion: v1
kind: Service
metadata:
  name: wso2ei-integrator-with-analytics-rdbms-service
  namespace: "$ns.k8s&wso2.ei"
spec:
  type: ClusterIP
  selector:
    deployment: wso2ei-with-analytics-mysql
    product: wso2ei
  ports:
    - name: mysql-port
      port: 3306
      targetPort: 3306
      protocol: TCP
---

apiVersion: v1
kind: Service
metadata:
  name: wso2ei-with-analytics-worker-service
  namespace: "$ns.k8s&wso2.ei"
spec:
  selector:
    deployment: wso2ei-with-analytics-worker
    product: wso2ei
  ports:
    - name: data-receiver-2
      port: 7612
      targetPort: 7612
      protocol: TCP
    - name: http-default
      port: 9091
      targetPort: 9091
      protocol: TCP
    - name: siddhi-defaul
      port: 7070
      targetPort: 8082
      protocol: TCP
    - name: siddhi-msf4j-https
      port: 7443
      targetPort: 11501
      protocol: TCP
    - name: data-receiver-1
      port: 7712
      targetPort: 7712
      protocol: TCP
    - name: http-msf4j-https
      port: 9444
      targetPort: 9444
      protocol: TCP
    - name: data-receiver-binary-1
      port: 9711
      targetPort: 9711
      protocol: TCP
    - name: data-receiver-binary-2
      port: 9611
      targetPort: 9611
      protocol: TCP
---

apiVersion: v1
kind: Service
metadata:
  name: wso2ei-with-analytics-ei-dashboard-service
  namespace: "$ns.k8s&wso2.ei"
  labels:
    deployment: wso2ei-with-analytics-dashboard
    product: wso2ei
spec:
  selector:
    deployment: wso2ei-with-analytics-dashboard
    product: wso2ei
  type: NodePort
  ports:
    -
      name: 'https'
      port: 9643
      protocol: TCP
      nodePort: "$nodeport.k8s.&.3.wso2ei"
  selector:
    deployment: wso2ei-with-analytics-dashboard
---

apiVersion: v1
kind: Service
metadata:
  name: wso2ei-integrator-service
  namespace: "$ns.k8s&wso2.ei"
  labels:
    deployment: wso2ei-integrator
    product: wso2ei
spec:
  selector:
    deployment: wso2ei-integrator
    product: wso2ei
  type: NodePort
  ports:
    - name: servlet-http
      port: 9763
      targetPort: 9763
      protocol: TCP
    - name: servlet-https
      port: 9443
      targetPort: 9443
      protocol: TCP
      nodePort: "$nodeport.k8s.&.1.wso2ei"
---

apiVersion: v1
kind: Service
metadata:
  name: wso2ei-integrator-gateway-service
  namespace: "$ns.k8s&wso2.ei"
  labels:
    deployment: wso2ei-integrator
    product: wso2ei
spec:
  selector:
    deployment: wso2ei-integrator
    product: wso2ei
  type: NodePort
  ports:
    - name: pass-through-http
      port: 8280
      targetPort: 8280
      protocol: TCP
    - name: pass-through-https
      port: 8243
      targetPort: 8243
      protocol: TCP
      nodePort: "$nodeport.k8s.&.2.wso2ei"
---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: wso2ei-with-analytics-mysql-deployment
  namespace: "$ns.k8s&wso2.ei"
spec:
  replicas: 1
  selector:
    matchLabels:
      deployment: wso2ei-with-analytics-mysql
      product: wso2ei
  template:
    metadata:
      labels:
        deployment: wso2ei-with-analytics-mysql
        product: wso2ei
    spec:
      containers:
        - name: wso2ei-integrator-mysql
          image: mysql:5.7
          imagePullPolicy: IfNotPresent
          securityContext:
            runAsUser: 999
          env:
            - name: MYSQL_ROOT_PASSWORD
              value: root
            - name: MYSQL_USER
              value: wso2carbon
            - name: MYSQL_PASSWORD
              value: wso2carbon
          ports:
            - containerPort: 3306
              protocol: TCP
          volumeMounts:
            - name: mysql-dbscripts
              mountPath: /docker-entrypoint-initdb.d
          args: ["--max-connections", "10000"]
      volumes:
        - name: mysql-dbscripts
          configMap:
            name: mysql-dbscripts
---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: wso2ei-with-analytics-worker-deployment
  namespace: "$ns.k8s&wso2.ei"
spec:
  replicas: 1
  minReadySeconds: 30
  strategy:
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
    type: RollingUpdate
  selector:
    matchLabels:
      deployment: wso2ei-with-analytics-worker
      node: wso2ei-with-analytics-worker
      product: wso2ei
  template:
    metadata:
      labels:
        deployment: wso2ei-with-analytics-worker
        node: wso2ei-with-analytics-worker
        product: wso2ei
    spec:
      containers:
        - name: wso2ei-with-analytics-worker
          image: "$image.pull.@.wso2"/wso2ei-analytics-worker:6.5.0
          env:
            -
              name: NODE_IP
              valueFrom:
                fieldRef:
                  fieldPath: status.podIP
          resources:
            limits:
              memory: "2Gi"
            requests:
              memory: "2Gi"
          livenessProbe:
            exec:
              command:
                - /bin/sh
                - -c
                - nc -z localhost 9444
            initialDelaySeconds: 10
            periodSeconds: 10
          readinessProbe:
            exec:
              command:
                - /bin/sh
                - -c
                - nc -z localhost 7712
            initialDelaySeconds: 10
            periodSeconds: 10
          lifecycle:
            preStop:
              exec:
                command:  ['sh', '-c', '${WSO2_SERVER_HOME}/bin/analytics-worker.sh stop']
          imagePullPolicy: Always
          securityContext:
            runAsUser: 802
          ports:
            -
              containerPort: 9444
              protocol: TCP
            -
              containerPort: 9091
              protocol: TCP
            -
              containerPort: 9711
              protocol: TCP
            -
              containerPort: 9611
              protocol: TCP
            -
              containerPort: 7712
              protocol: TCP
            -
              containerPort: 7612
              protocol: TCP
            -
              containerPort: 7070
              protocol: TCP
            -
              containerPort: 7443
              protocol: TCP
            -
              containerPort: 9894
              protocol: TCP
          volumeMounts:
            - name: ei-analytics-conf-worker
              mountPath: /home/wso2carbon/wso2-config-volume/wso2/analytics/conf/worker
      initContainers:
        - name: init-ei-with-analytics
          image: busybox
          command: ['sh', '-c', 'echo -e "checking for the availability of MySQL"; while ! nc -z wso2ei-integrator-with-analytics-rdbms-service 3306; do sleep 1; printf "-"; done; echo -e "  >> MySQL server started";']
      serviceAccountName: "wso2svc-account"
      imagePullSecrets:
        - name: wso2creds
      volumes:
        - name: ei-analytics-conf-worker
          configMap:
            name: ei-analytics-conf-worker
---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: wso2ei-with-analytics-dashboard-deployment
  namespace: "$ns.k8s&wso2.ei"
  labels:
    deployment: wso2ei-with-analytics-dashboard
    product: wso2ei
spec:
  replicas: 1
  minReadySeconds: 30
  strategy:
    type: Recreate
  selector:
    matchLabels:
      deployment: wso2ei-with-analytics-dashboard
      product: wso2ei
  template:
    metadata:
      labels:
        deployment: wso2ei-with-analytics-dashboard
        product: wso2ei
    spec:
      containers:
        - image: "$image.pull.@.wso2"/wso2ei-analytics-dashboard:6.5.0
          name: wso2ei-with-analytics-dashboard
          imagePullPolicy: Always
          ports:
            -
              containerPort: 9643
              protocol: "TCP"
          livenessProbe:
            exec:
              command:
                - /bin/sh
                - -c
                - nc -z localhost 9643
          volumeMounts:
            - name: ei-analytics-dashboard-conf-dashboard
              mountPath: "/home/wso2carbon/wso2-config-volume/wso2/analytics/conf/dashboard"
          lifecycle:
            preStop:
              exec:
                command:  ['sh', '-c', '${WSO2_SERVER_HOME}/bin/analytics-dashboard.sh stop']
      initContainers:
        - name: init-ei-dashboard
          image: busybox
          command: ['sh', '-c', 'echo -e "checking for the availability of Enterprise Integrator Analytics"; while ! nc -z wso2ei-with-analytics-worker-service 7712; do sleep 1; printf "-"; done; echo -e " >> Enterprise Integrator Analytics started";']
      imagePullSecrets:
        - name: wso2creds
      securityContext:
        runAsUser: 802
      volumes:
        - name: ei-analytics-dashboard-conf-dashboard
          configMap:
            name: ei-analytics-dashboard-conf-dashboard
      serviceAccountName: "wso2svc-account"
---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: wso2ei-with-analytics-integrator-deployment
  namespace: "$ns.k8s&wso2.ei"
spec:
  replicas: 1
  minReadySeconds: 30
  strategy:
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
    type: RollingUpdate
  selector:
    matchLabels:
      deployment: wso2ei-integrator
      product: wso2ei
  template:
    metadata:
      labels:
        deployment: wso2ei-integrator
        product: wso2ei
    spec:
      containers:
        - name: wso2ei-integrator
          image: "$image.pull.@.wso2"/wso2ei-integrator:6.5.0
          livenessProbe:
            exec:
              command:
                - /bin/bash
                - -c
                - nc -z localhost 9443
            initialDelaySeconds: 60
            periodSeconds: 10
          readinessProbe:
            exec:
              command:
                - /bin/bash
                - -c
                - nc -z localhost 9443
            initialDelaySeconds: 60
            periodSeconds: 10
          imagePullPolicy: Always
          ports:
            - containerPort: 8280
              protocol: TCP
            - containerPort: 8243
              protocol: TCP
            - containerPort: 9763
              protocol: TCP
            - containerPort: 9443
              protocol: TCP
          volumeMounts:
            - name: integrator-conf
              mountPath: /home/wso2carbon/wso2-config-volume/conf
            - name: integrator-conf-axis2
              mountPath: /home/wso2carbon/wso2-config-volume/conf/axis2
            - name: integrator-conf-datasources
              mountPath: /home/wso2carbon/wso2-config-volume/conf/datasources
      initContainers:
        - name: init-ei
          image: busybox
          command: ['sh', '-c', 'echo -e "checking for the availability of Enterprise Integrator Analytics"; while ! nc -z wso2ei-with-analytics-worker-service 7712; do sleep 1; printf "-"; done; echo -e " >> Enterprise Integrator Analytics started";']
      serviceAccountName: "wso2svc-account"
      imagePullSecrets:
        - name: wso2creds
      volumes:
        - name: integrator-conf
          configMap:
            name: integrator-conf
        - name: integrator-conf-axis2
          configMap:
            name: integrator-conf-axis2
        - name: integrator-conf-datasources
          configMap:
            name: integrator-conf-datasources
---
EOF
}
#bash functions
function usage(){
  echo "Usage: "
  echo -e "-d, --deploy     Deploy WSO2 Enterprise Integrator"
  echo -e "-u, --undeploy   Undeploy WSO2 Enterprise Integrator"
  echo -e "-h, --help       Display usage instrusctions"
}
function undeploy(){
  echo "Undeploying WSO2 Enterprise Integrator ..."
  kubectl delete ns $namespace
  echo "Done."
  exit 0
}
function echoBold () {
    echo -en  $'\e[1m'"${1}"$'\e[0m'
}

function display_msg(){
    msg=$@
    echoBold "${msg}"
    exit 1
}

function st(){
  cycles=${1}
  i=0
  while [[ i -lt $cycles ]]
  do
    echoBold "* "
    let "i=i+1"
  done
}
function sp(){
  cycles=${1}
  i=0
  while [[ i -lt $cycles ]]
  do
    echoBold " "
    let "i=i+1"
  done
}
function product_name() {
  echo -e "\n"
  #wso2ei
  st 1; sp 8; st 1; sp 2; sp 1; st 3; sp 3; sp 2; st 3; sp 4; sp 1; st 3; sp 3; sp 8; st 5; sp 2; st 5
  echo ""
  st 1; sp 8; st 1; sp 2; st 1; sp 4; st 1; sp 2; st 1; sp 6; st 1; sp 2; st 1; sp 4; st 1; sp 2; sp 8; st 1; sp 8; sp 2; sp 4; st 1
  echo ""
  st 1; sp 3; st 1; sp 3; st 1; sp 2; st 1; sp 8; st 1; sp 6; st 1; sp 2; sp 6; st 1; sp 2; sp 8; st 1; sp 8; sp 2; sp 4; st 1
  echo ""
  st 1; sp 2; st 1; st 1; sp 2; st 1; sp 2; sp 1; st 3; sp 3; st 1; sp 6; st 1; sp 2; sp 4; st 1; sp 4; st 3; sp 2; st 5; sp 2; sp 4; st 1
  echo ""
  st 1; sp 1; st 1; sp 2; st 1; sp 1; st 1; sp 2; sp 6; st 1; sp 2; st 1; sp 6; st 1; sp 2; sp 2; st 1; sp 6; sp 8; st 1; sp 8; sp 2; sp 4; st 1;
  echo ""
  st 2; sp 4; st 2; sp 2; st 1; sp 4; st 1; sp 2; st 1; sp 6; st 1; sp 2; st 1; sp 8; sp 8; st 1; sp 8; sp 2; sp 4; st 1;
  echo ""
  st 1; sp 8; st 1; sp 2; sp 1; st 3; sp 3; sp 2; st 3; sp 4; st 4; sp 2; sp 8; st 5; sp 2; st 5
  echo -e "\n\n"

}

function get_creds(){
  while [[ -z "$WUMUsername" ]]
  do
        read -p "$(echoBold "Enter your WSO2 subscription username: ")" WUMUsername
        if [[ -z "$WUMUsername" ]]
        then
           echo "wso2-subscription-username cannot be empty"
        fi
  done

  while [[ -z "$WUMPassword" ]]
  do
        read -sp "$(echoBold "Enter your WSO2 subscription password: ")" WUMPassword
        echo ""
        if [[ -z "$WUMPassword" ]]
        then
          echo "wso2-subscription-password cannot be empty"
        fi
  done
}
function validate_ip(){
    ip_check=$1
    if [[ $ip_check =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
      IFS='.'
      ip=$ip_check
      set -- $ip
      if [[ $1 -le 255 ]] && [[ $2 -le 255 ]] && [[ $3 -le 255 ]] && [[ $4 -le 255 ]]; then
        IFS=''
        NODE_IP=$ip_check
      else
        IFS=''
        echo "Invalid IP. Please try again."
        NODE_IP=""
      fi
    else
      echo "Invalid IP. Please try again."
      NODE_IP=""
    fi
}
function get_node_ip(){
  NODE_IP=$(kubectl get nodes -o jsonpath='{.items[*].status.addresses[?(@.type=="ExternalIP")].address}')

  if [[ -z $NODE_IP ]]
  then
      if [[ $(kubectl config current-context)="minikube" ]]
      then
          NODE_IP=$(minikube ip)
      else
        echo "We could not find your cluster node-ip."
        while [[ -z "$NODE_IP" ]]
        do
              read -p "$(echo "Enter one of your cluster Node IPs to provision instant access to server: ")" NODE_IP
              if [[ -z "$NODE_IP" ]]
              then
                echo "cluster node ip cannot be empty"
              else
                validate_ip $NODE_IP
              fi
        done
      fi
  fi
  set -- $NODE_IP; NODE_IP=$1
}
function get_nodePorts(){
  LOWER=30000; UPPER=32767;
  if [ "$randomPort" == "True" ]; then
    NP_1=0; NP_2=0; NP_3=0;
    while [ $NP_1 -lt $LOWER ] || [ $NP_2 -lt $LOWER ] || [ $NP_3 -lt $LOWER ]
    do
      NP_1=$RANDOM; NP_2=$RANDOM; NP_3=$RANDOM
      let "NP_1 %= $UPPER"; let "NP_2 %= $UPPER"; let "NP_3 %= $UPPER"
    done
  fi
  echo -e "[INFO] nodePorts  are set to $NP_1/ $NP_2/ $NP_3"
}
function progress_bar(){
  dep_status=$(kubectl get deployments -n wso2 -o jsonpath='{.items[?(@.spec.selector.matchLabels.product=="wso2ei")].status.conditions[?(@.type=="Available")].status}')
  pod_status=$(kubectl get pods -n wso2 -o jsonpath='{.items[?(@.metadata.labels.product=="wso2ei")].status.conditions[*].status}')

  num_true_const=0; progress_unit="";num_true=0; time_proc=0;

  arr_dep=($dep_status); arr_pod=($pod_status)

  let "length_total= ${#arr_pod[@]} + ${#arr_dep[@]}";

  echo ""

  while [[ $num_true -lt $length_total ]]
  do

      sleep 3

      num_true=0
      dep_status=$(kubectl get deployments -n wso2 -o jsonpath='{.items[?(@.spec.selector.matchLabels.product=="wso2ei")].status.conditions[?(@.type=="Available")].status}')
      pod_status=$(kubectl get pods -n wso2 -o jsonpath='{.items[?(@.metadata.labels.product=="wso2ei")].status.conditions[*].status}')

      arr_dep=($dep_status); arr_pod=($pod_status); let "length_total= ${#arr_pod[@]} + ${#arr_dep[@]}";

      for ele_dep in $dep_status
      do
          if [ "$ele_dep" = "True" ]
          then
              let "num_true=num_true+1"
          fi
      done

      for ele_pod in $pod_status
      do
          if [ "$ele_pod" = "True" ]
          then
              let "num_true=num_true+1"
          fi
      done
      printf "Processing WSO2 Enterprise Integrator ... |"

      printf "%-$((5 * ${length_total-1}))s| $(($num_true_const * 100/ $length_total))"; echo -en ' %\r'

      printf "Processing WSO2 Enterprise Integrator ... |"
      s=$(printf "%-$((5 * ${num_true_const}))s" "H")
      echo -en "${s// /H}"

      printf "%-$((5 * $(($length_total - $num_true_const))))s| $((100 * $(($num_true_const))/ $length_total))"; echo -en ' %\r'

      if [ $num_true -ne $num_true_const ]
      then
          i=0
          while [[ $i -lt  $((5 * $((${num_true} - ${num_true_const})))) ]]
          do
              let "i=i+1"
              progress_unit=$progress_unit"H"
              printf "Processing WSO2 Enterprise Integrator ... |"
              echo -n $progress_unit
              printf "%-$((5 * $((${length_total} - ${num_true_const})) - $i))s| $(($(( 100 * $(($num_true_const))/ $length_total)) +  $((20 * $i/$length_total)) ))"; echo -en ' %\r'
              sleep 0.25
          done
          num_true_const=$num_true
          time_proc=0
        else
            let "time_proc=time_proc + 5"
      fi

      printf "Processing WSO2 Enterprise Integrator ... |"

      printf "%-$((5 * ${length_total-1}))s| $(($num_true_const * 100/ $length_total))"; echo -en ' %\r'

      printf "Processing WSO2 Enterprise Integrator ... |"
      s=$(printf "%-$((5 * ${num_true_const}))s" "H")
      echo -en "${s// /H}"

      printf "%-$((5 * $(($length_total - $num_true_const))))s| $((100 * $(($num_true_const))/ $length_total))"; echo -en ' %\r'

      sleep 1
      if [[ $time_proc -gt 250 ]]
      then
          echoBold "\n\nSomething went wrong! Please Follow \"https://wso2.com/products/install/faq/#Kubernetes\" for more information\n"
          exit 2
      fi
  done

  echo -e "\n"

}

function deploy(){
    # checking for required tools
    if [[ ! $(which kubectl) ]]
    then
       display_msg "Please install Kubernetes command-line tool (kubectl) before you start the setup\n"
    fi

    if [[ ! $(which base64) ]]
    then
       display_msg "Please install base64 before you start the setup\n"
    fi
    echoBold "Checking for an enabled cluster... Your patience is appreciated..."
    cluster_isReady=$(kubectl cluster-info) > /dev/null 2>&1  || true

    if [[ ! $cluster_isReady == *"DNS"* ]]
    then
        display_msg "\nPlease enable your cluster before running the setup.\n\nIf you don't have a kubernetes cluster, follow: https://kubernetes.io/docs/setup/\n\n"
    fi
    echoBold "Done.\n"

    #displaying wso2 product name
    product_name

    # check if testgrid
    if test -f $TG_PROP; then
        source $TG_PROP
    else
        get_creds # get wso2 subscription parameters
    fi

    # checking if inputs are empty
    get_node_ip

    # create and encode username/password pair
    auth="$WUMUsername:$WUMPassword"
    authb64=`echo -n $auth | base64`

    # create authorisation code
    authstring='{"auths":{"docker.wso2.com": {"username":"'${WUMUsername}'","password":"'${WUMPassword}'","email":"'${WUMUsername}'","auth":"'${authb64}'"}}}'

    # encode in base64
    secdata=`echo -n $authstring | base64`

    for i in $secdata; do
      str_sec=$str_sec$i
    done

    # If TG random nodePort else default nodePort
    get_nodePorts

    # create kubernetes object yaml
    create_yaml

    sed -i.bak 's/"$ns.k8s&wso2.ei"/'$namespace'/g' $k8s_obj_file
    sed -i.bak 's/"$string.&.secret.auth.data"/'$secdata'/g' $k8s_obj_file
    sed -i.bak 's/"ip.node.k8s.&.wso2.ei"/'$NODE_IP'/g' $k8s_obj_file
    sed -i.bak 's/"$nodeport.k8s.&.1.wso2ei"/'$NP_1'/g' $k8s_obj_file
    sed -i.bak 's/"$nodeport.k8s.&.2.wso2ei"/'$NP_2'/g' $k8s_obj_file
    sed -i.bak 's/"$nodeport.k8s.&.3.wso2ei"/'$NP_3'/g' $k8s_obj_file
    sed -i.bak 's|"$image.pull.@.wso2"|'$IMG_DEST'|g' $k8s_obj_file

    rm deployment.yaml.bak

    if ! test -f $TG_PROP; then
        echoBold "\nDeploying wso2 Enterprise Integrator ... \n"

        # create kubernetes deployment
        kubectl create -f ${k8s_obj_file}

        # waiting until deployment is ready
        progress_bar

        echoBold "Successfully deployed WSO2 Enterprise Integrator.\n\n"

        echoBold "1. Try navigating to https://$NODE_IP:30443/carbon/ and https://$NODE_IP:30643/portal/ from your favourite browser using\n"
        echoBold "\tusername: admin\n"
        echoBold "\tpassword: admin\n"
        echoBold "2. Follow \"https://docs.wso2.com/display/EI640/Quick+Start+Guide\" to start using WSO2 Enterprise Integrator.\n\n"
    fi
}
arg=$1
if [[ -z $arg ]]; then
    echoBold "Expected parameter is missing\n"
    usage
else
    case $arg in
      -d|--deploy)
        deploy
        ;;
      -u|--undeploy)
        undeploy
        ;;
      -h|--help)
        usage
        ;;
      *)
        echoBold "Invalid parameter : $arg\n"
        usage
        ;;
    esac
fi
