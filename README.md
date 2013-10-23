artifact-library
================


Use this as a maven Library for public accessible Artifacts.

This is Usefull for building AppDynamics Extensions using maven or Gradle


* Gradle Example

	repositories {	
    	// Use 'maven central' for resolving your dependencies.
    	mavenCentral()
    	
    	// Use the AppDynamics Repository for AppDynamics specific Artifacts
    	maven {
        	url "https://raw.github.com/Appdynamics/artifact-library/master/repo/"
    	}
	}

