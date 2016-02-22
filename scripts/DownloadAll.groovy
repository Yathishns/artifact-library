#!/usr/local/bin/groovy
import groovy.json.*


if (args.length != 2) {
	println "Usage :  DownloadAll.groovy <releaseBuildUrl> <localTemp>"
	return 10;
}


//          C
//def url = "http://leeroy-jenkins.corp.appdynamics.com/job/"+args[0]+".next-build/lastSuccessfulBuild/artifact/artifacts.json"
//def url = "http://leeroy-jenkins.corp.appdynamics.com/view/All/job/"+args[0]+".next-publish/lastSuccessfulBuild/artifact/artifacts.json"
def url = args[0] 
def local = args[1]


println "Downloading from : $url"
new File(local).mkdirs();


def text = new URL(url).text
// removed since 4.1.3
//.split("\n")[1..-1].join("\n")
def json = new JsonSlurper().parseText(text)





downloadFile (json,"com.appdynamics.machineagent:machineagent:?@zip","$local/machineagent.zip")

downloadFile (json,"com.appdynamics.agent:app-server-agent-obfuscated:?@zip","$local/AppServerAgent.zip")
downloadFile (json,"com.appdynamics.agent:app-server-agent:releaseZip-?@zip","$local/AppServerAgent.zip")

downloadFile (json,"com.appdynamics.agent:app-server-agent:debugZip-?@zip","$local/AppServerAgentPlain.zip")

downloadFile (json,"com.appdynamics.controller:controller-api:?@jar","$local/controller-api.jar")
downloadFile (json,"com.appdynamics.agent:app-server-agent-obfuscated-zkm-changelog:?@txt","$local/agentChangelogZKM.txt")
downloadFile (json,"com.appdynamics.controller:controller-zkm-changelog:?@txt","$local/controller_zkm.txt");





def downloadFile(json,id,filename) {
	def file = json.UrlMap.get(id)

	if (file == null) {
		println "Couldn't find $filename : Query $id"
	} else {

		download(file,filename)
		
		
	}
}

def download (def url, String filename) {
	println " --> Downloading to local file $filename from \n --< $url"
	
	def proc = "curl -o $filename $url ".execute()

	Thread.start { 
		System.err << proc.err;
		System.out << proc.out;
	} 

	proc.waitFor()

	sleep (500)
	println "--< finished \n\n"
}
