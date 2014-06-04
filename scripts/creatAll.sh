#!/bin/bash
/vlab/maven/artifact-library/scripts/createAgentArctifacts.sh 3.8.2 /vlab/maven/artifact-library/repo /vlab/development/appDynamics/master/codebase
/vlab/maven/artifact-library/scripts/createSecretAgentArtifacts.sh 3.8.2 /vlab/maven/private-artifact-library/repo /vlab/development/appDynamics/master/codebase
/vlab/maven/artifact-library/scripts/createSecretArtifacts.sh 3.8.2 /vlab/maven/private-artifact-library/repo /vlab/development/appDynamics/master/codebase