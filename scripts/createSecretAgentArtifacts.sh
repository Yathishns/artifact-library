#!/bin/bash

cdir="$(pwd)"

echo "Starting at $cdir"
maven=$2
codebase=$3
version=$1
tmpD=/tmp/mv/$version/agent
mkdir -p $tmpD

echo "Updating git repository at $codebase"
cd $codebase
git pull
git checkout v${version}GA

echo "Building and packaging now"
sleep 2
cd $codebase/agent/java/core

ant build

# Obfuscation
mvn deploy:deploy-file   \
-DgroupId=com.appdynamics.agent.develop \
-DartifactId=AppAgentPlain \
-Dversion=$version \
-Dpackaging=jar \
-DrepositoryId=github \
-Durl=file://$maven \
-Dfile=$codebase/agent/java/core/build/temp/lib/appagent.jar

echo BUILD Dynamic Services
find $codebase/dynamic-services/services -d 1 -not -name ".*"  -exec gradle -p "{}" build ";"

echo BUILD Production Package
ant package-production

export CODEBASE_HOME=$codebase
find $codebase/dynamic-services/services/*/build/libs -name "*.jar" -exec obfuscateServiceJar.sh 3.7.15 "{}" ";"

mvn deploy:deploy-file   \
-DgroupId=com.appdynamics \
-DartifactId=AppServerAgent \
-Dversion=$version \
-Dpackaging=zip \
-DrepositoryId=github \
-Durl=file://$maven \
-Dfile=$codebase/agent/java/core/dist/AppServerAgent.zip

mvn deploy:deploy-file   \
-DgroupId=com.appdynamics.agent.services \
-DartifactId=ScanThreadsForBTs \
-Dversion=$version \
-Dpackaging=jar \
-DrepositoryId=github \
-Durl=file://$maven \
-Dfile=$codebase/dynamic-services/services/ScanThreadsForBTs/build/obfuscated/ScanThreadsForBTs.jar

mvn deploy:deploy-file   \
-DgroupId=com.appdynamics.agent.services \
-DartifactId=SocketTrace \
-Dversion=$version \
-Dpackaging=jar \
-DrepositoryId=github \
-Durl=file://$maven \
-Dfile=$codebase/dynamic-services/services/SocketTrace/build/obfuscated/SocketTrace.jar

mvn deploy:deploy-file   \
-DgroupId=com.appdynamics.agent.services \
-DartifactId=ThreadProfiler \
-Dversion=$version \
-Dpackaging=jar \
-DrepositoryId=github \
-Durl=file://$maven \
-Dfile=$codebase/dynamic-services/services/ThreadProfiler/build/obfuscated/ThreadProfiler.jar


mvn deploy:deploy-file   \
-DgroupId=com.appdynamics.agent.services \
-DartifactId=genericInterceptor \
-Dversion=$version \
-Dpackaging=jar \
-DrepositoryId=github \
-Durl=file://$maven \
-Dfile=$codebase/dynamic-services/services/genericInterceptor/build/obfuscated/genericInterceptor.jar



# Obfuscation
mvn deploy:deploy-file   \
-DgroupId=com.appdynamics.agent.develop \
-DartifactId=ObfuscationAdapter \
-Dversion=$version \
-Dpackaging=jar \
-DrepositoryId=github \
-Durl=file://$maven \
-Dfile=$codebase/dynamic-services/obfuscation-adapter/build/libs/obfuscation-adapter.jar

mvn deploy:deploy-file   \
-DgroupId=com.appdynamics.agent.develop \
-DartifactId=ObfuscationAsm \
-Dversion=$version \
-Dpackaging=jar \
-DrepositoryId=github \
-Durl=file://$maven \
-Dfile=$codebase/agent/java/core/build/temp/lib/tp/asm-3.3.1.jar

# Obfuscation
mvn deploy:deploy-file   \
-DgroupId=com.appdynamics.agent.develop \
-DartifactId=ObfuscationMapping \
-Dversion=$version \
-Dpackaging=map \
-DrepositoryId=github \
-Durl=file://$maven \
-Dfile=$codebase/agent/java/core/zkm/app-agent-changeLog.txt 

# Obfuscation
mvn deploy:deploy-file   \
-DgroupId=com.appdynamics.agent.develop \
-DartifactId=AppAgent \
-Dversion=$version \
-Dpackaging=jar \
-DrepositoryId=github \
-Durl=file://$maven \
-Dfile=$codebase/agent/java/core/build/original/appagent.jar


mvn deploy:deploy-file   \
-DgroupId=com.appdynamics.develop \
-DartifactId=Log4J \
-Dversion=$version \
-Dpackaging=jar \
-DrepositoryId=github \
-Durl=file://$maven \
-Dfile=$codebase/thirdparty/lib/log4j/namespace-safe/singularity-log4j.jar

cd $codebase
git checkout master 
