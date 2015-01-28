#!/bin/bash

cdir="$(pwd)"

echo "Starting at $cdir"
maven=$1
smaven=$2
codebase=$3
version=$4
baselink=$5


# USAGE 
# /vlab/maven/artifact-library/scripts/createNew.sh /vlab/maven/artifact-library/repo  /vlab/maven/private-artifact-library/repo /vlab/development/appDynamics/master/codebase version

tmpD=/tmp/mv/$version
echo $tmpD
mkdir -p $tmpD

echo "Updating git repository at $codebase"
cd $codebase



echo "Please make sure to have a compiled agent (ant build) in Version $version before hit enter to continue........"
read
# Obfuscation
mvn deploy:deploy-file   \
-DgroupId=com.appdynamics.agent.develop \
-DartifactId=AppAgentPlain \
-Dversion=$version \
-Dpackaging=jar \
-DrepositoryId=github \
-Durl=file://$smaven \
-Dfile=$codebase/agent/core/java-core/build/temp/lib/appagent.jar


# Obfuscation
mvn deploy:deploy-file   \
-DgroupId=com.appdynamics.agent.develop \
-DartifactId=ObfuscationAdapter \
-Dversion=$version \
-Dpackaging=jar \
-DrepositoryId=github \
-Durl=file://$smaven \
-Dfile=$codebase/dynamic-services/obfuscation-adapter/build/libs/obfuscation-adapter.jar

mvn deploy:deploy-file   \
-DgroupId=com.appdynamics.agent.develop \
-DartifactId=ObfuscationAsm \
-Dversion=$version \
-Dpackaging=jar \
-DrepositoryId=github \
-Durl=file://$smaven \
-Dfile=$codebase/agent/core/java-core/build/temp/lib/tp/asm-5.0.1.jar

