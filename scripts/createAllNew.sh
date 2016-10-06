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

echo "Updating git repository at $codebase"
cd $codebase

mkdir -p $tmpD
mkdir -p $tmpD/agent
mkdir -p $tmpD/dl

#groovy $cdir/DownloadAll.groovy $baselink $tmpD/dl



cd $tmpD/agent
unzip $tmpD/dl/machineagent.zip machineagent.jar


mkdir t
cd t
jar xf ../machineagent.jar
jar cf ../agent-api.jar com/singularity/ee/agent/systemagent/api

mvn deploy:deploy-file   \
-DgroupId=com.appdynamics \
-DartifactId=machineagent \
-Dversion=$version \
-Dpackaging=jar \
-DrepositoryId=github \
-Durl=file://$maven \
-Dfile=$tmpD/agent/machineagent.jar 


mvn deploy:deploy-file   \
-DgroupId=com.appdynamics \
-DartifactId=agent-api \
-Dversion=$version \
-Dpackaging=jar \
-DrepositoryId=github \
-Durl=file://$maven \
-Dfile=$tmpD/agent/agent-api.jar 


mkdir -p cd $tmpD/agentTmp
cd $tmpD/agentTmp
unzip $tmpD/dl/AppServerAgent.zip 
mv ver*/* .


#unzip $tmpD/dl/AppServerAgent.zip lib/appagent.jar
#unzip $tmpD/dl/AppServerAgent.zip lib/singularity-log4j.jar
#unzip $tmpD/dl/AppServerAgent.zip javaagent.jar



mvn deploy:deploy-file   \
-DgroupId=com.appdynamics \
-DartifactId=AppServerAgent \
-Dversion=$version \
-Dpackaging=zip \
-DrepositoryId=github \
-Durl=file://$smaven \
-Dfile=$tmpD/dl/AppServerAgent.zip

mvn deploy:deploy-file   \
-DgroupId=com.appdynamics \
-DartifactId=MachineAgent \
-Dversion=$version \
-Dpackaging=zip \
-DrepositoryId=github \
-Durl=file://$smaven \
-Dfile=$tmpD/dl/machineagent.zip

# Obfuscation
mvn deploy:deploy-file   \
-DgroupId=com.appdynamics.agent.develop \
-DartifactId=ObfuscationMapping \
-Dversion=$version \
-Dpackaging=map \
-DrepositoryId=github \
-Durl=file://$smaven \
-Dfile=$tmpD/dl/agentChangelogZKM.txt

# Obfuscation
mvn deploy:deploy-file   \
-DgroupId=com.appdynamics.agent.develop \
-DartifactId=AppAgent \
-Dversion=$version \
-Dpackaging=jar \
-DrepositoryId=github \
-Durl=file://$smaven \
-Dfile=$tmpD/agentTmp/lib/appagent.jar


mvn deploy:deploy-file   \
-DgroupId=com.appdynamics.develop \
-DartifactId=Log4J \
-Dversion=$version \
-Dpackaging=jar \
-DrepositoryId=github \
-Durl=file://$smaven \
-Dfile=$tmpD/agentTmp/lib/singularity-log4j.jar

mvn deploy:deploy-file   \
-DgroupId=com.appdynamics \
-DartifactId=controller-api \
-Dversion=$version \
-Dpackaging=jar \
-DrepositoryId=github \
-Durl=file://$smaven \
-Dfile=$tmpD/dl/controller-api.jar 

mvn deploy:deploy-file   \
-DgroupId=com.appdynamics \
-DartifactId=controller-auth \
-Dversion=$version \
-Dpackaging=jar \
-DrepositoryId=github \
-Durl=file://$smaven \
-Dfile=$tmpD/dl/controller_auth.jar
 


mvn deploy:deploy-file   \
-DgroupId=com.appdynamics \
-DartifactId=javaagent \
-Dversion=$version \
-Dpackaging=jar \
-DrepositoryId=github \
-Durl=file://$smaven \
-Dfile=$tmpD/agentTmp/javaagent.jar


mkdir -p cd $tmpD/agentTmpPlain
cd $tmpD/agentTmpPlain
unzip $tmpD/dl/AppServerAgentPlain.zip 
mv ver*/* .


mvn deploy:deploy-file   \
-DgroupId=com.appdynamics.agent.develop \
-DartifactId=AppAgentPlain \
-Dversion=$version \
-Dpackaging=jar \
-DrepositoryId=github \
-Durl=file://$smaven \
-Dfile=$tmpD/agentTmpPlain/lib/appagent.jar

mvn deploy:deploy-file   \
-DgroupId=com.appdynamics.agent.develop \
-DartifactId=ObfuscationAsm \
-Dversion=$version \
-Dpackaging=jar \
-DrepositoryId=github \
-Durl=file://$smaven \
-Dfile=$tmpD/agentTmpPlain/lib/tp/asm-5.0.1.jar
# rm -rf  $tmpD


mkdir -p $tmpD/ear
cd $tmpD/ear

unzip $tmpD/dl/controller.ear controller-beans.jar
mvn deploy:deploy-file   \
-DgroupId=com.appdynamics \
-DartifactId=controller-beans \
-Dversion=$version \
-Dpackaging=jar \
-DrepositoryId=github \
-Durl=file://$smaven \
-Dfile=$tmpD/ear/controller-beans.jar


