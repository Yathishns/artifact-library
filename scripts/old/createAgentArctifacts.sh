#!/bin/bash

cdir="$(pwd)"

echo "Starting at $cdir"
maven=$2
codebase=$3
version=$1
tmpD=/tmp/mv/$version/agent

echo "Updating git repository at $codebase"
cd $codebase
git pull
git checkout v${version}GA

echo "Building and packaging now"
sleep 2
cd $codebase/agent/system-agent
ant package
mkdir -p $tmpD
cp build/temp/machineagent.jar $tmpD/machineagent.jar
cd $tmpD
mkdir t
cd t
jar xvf ../machineagent.jar
jar cvf ../agent-api.jar com/singularity/ee/agent/systemagent/api


mvn deploy:deploy-file   \
-DgroupId=com.appdynamics \
-DartifactId=machineagent \
-Dversion=$version \
-Dpackaging=jar \
-DrepositoryId=github \
-Durl=file://$maven \
-Dfile=$tmpD/machineagent.jar 


mvn deploy:deploy-file   \
-DgroupId=com.appdynamics \
-DartifactId=agent-api \
-Dversion=$version \
-Dpackaging=jar \
-DrepositoryId=github \
-Durl=file://$maven \
-Dfile=$tmpD/agent-api.jar 

cd $codebase
git checkout master 
