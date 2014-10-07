#!/bin/bash
version=$1
/vlab/maven/artifact-library/scripts/createAgentArctifacts.sh ${version} /vlab/maven/artifact-library/repo /vlab/development/appDynamics/master/codebase
/vlab/maven/artifact-library/scripts/createSecretAgentArtifacts.sh ${version} /vlab/maven/private-artifact-library/repo /vlab/development/appDynamics/master/codebase
/vlab/maven/artifact-library/scripts/createSecretArtifacts.sh ${version} /vlab/maven/private-artifact-library/repo /vlab/development/appDynamics/master/codebase