./createPlainAgent.sh /vlab/maven/artifact-library/repo \
				 /vlab/maven/private-artifact-library/repo \
				 $CODEBASE \
				 $1  http://leeroy-jenkins.corp.appdynamics.com/job/$1.next-build/lastSuccessfulBuild/artifact/PrebuiltArtifactMap.json

