Artifact-Library
================


Use this as a maven Library for public accessible Artifacts.

This is useful for building AppDynamics Extensions using maven or Gradle


* Gradle Example

        repositories {	
    	   mavenCentral()
    	
    	   maven {
        	   url "https://raw.github.com/Appdynamics/artifact-library/master/repo/"
    	   }
	    }

