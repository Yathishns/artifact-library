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
cd $codebase/controller/controller-api
ant package

cp build/controller-api.jar $tmpD/controller-api.jar
cd $tmpD


mvn deploy:deploy-file   \
-DgroupId=com.appdynamics \
-DartifactId=controller-api \
-Dversion=$version \
-Dpackaging=jar \
-DrepositoryId=github \
-Durl=file://$maven \
-Dfile=$tmpD/controller-api.jar 


cd $codebase/agent/java/core
ant clean build package
cp build/temp/javaagent.jar $tmpD/javaagent.jar

mvn deploy:deploy-file   \
-DgroupId=com.appdynamics \
-DartifactId=javaagent \
-Dversion=$version \
-Dpackaging=jar \
-DrepositoryId=github \
-Durl=file://$maven \
-Dfile=$tmpD/javaagent.jar

cd $codebase
git checkout master 
