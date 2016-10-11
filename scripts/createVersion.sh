#./createAllNew.sh /vlab/maven/artifact-library/repo \
#				 /vlab/maven/private-artifact-library/repo \
#				 /vlab/development/appdynamics/master/codebase \
#				 $1 http://leeroy-jenkins.corp.appdynamics.com/view/All/job/$1.next-publish/lastSuccessfulBuild/artifact/artifacts.json


#"http://leeroy-jenkins.corp.appdynamics.com/job/${args[0]}.next-build/lastSuccessfulBuild/artifact/PrebuiltArtifactMap.json"

./createAllNew.sh /vlab/maven/artifact-library/repo \
				 /vlab/maven/private-artifact-library/repo \
				 /vlab/development/appdynamics/master/codebase \
				 $1  https://build.corp.appdynamics.com/releases/v$1GA/manifest.json

#./createPlainAgent.sh /vlab/maven/artifact-library/repo \
#				 /vlab/maven/private-artifact-library/repo \
#				 /vlab/development/appdynamics/master/codebase \
#				 $1  http://leeroy-jenkins.corp.appdynamics.com/job/$1.next-build/lastSuccessfulBuild/artifact/PrebuiltArtifactMap.json

