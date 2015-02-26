#!/usr/local/bin/groovy

import groovy.json.*


if (args.length != 2) {
	println "Usage :  DownloadAll.groovy <releaseBuildUrl> <localTemp>"
	return 10;
}



def url = args[0]
def local = args[1]


println "Downloading from : $url"
new File(local).mkdirs();

def json = new JsonSlurper().parseText(new URL(url).text)








downloadFile (json,"com.appdynamics.machineagent:machineagent","$local/machineagent.zip")
downloadFile (json,"com.appdynamics.agent:app-server-agent-obfuscated:","$local/AppServerAgent.zip")
downloadFile (json,"com.appdynamics.controller:controller-api:","$local/controller-api.jar")
downloadFile (json,"com.appdynamics.agent:app-server-agent-obfuscated-zkm-changelog:","$local/agentChangelogZKM.txt")






def downloadFile(json,id,filename) {
	def file = json.find { item ->
		return item?.id?.contains(id)
	}

	if (file == null) {
		println "Couldn't find $filename : Query $id"
	} else {
		println "Downloading : $file.url "

    	def target = new FileOutputStream(filename)
	    def out = new BufferedOutputStream(target)
    	out << new URL(file.url).openStream()
    	out.close()
		
	}
}

