#!/usr/bin/env groovy 

@Grab(group= 'org.codehaus.groovy.modules.http-builder', module= 'http-builder', version='0.7.1')

import groovy.json.*
import groovyx.net.http.ContentType
import groovyx.net.http.HTTPBuilder
import groovyx.net.http.HttpResponseDecorator
import groovyx.net.http.URIBuilder

import java.security.MessageDigest
import java.text.DecimalFormat

import static groovyx.net.http.ContentType.TEXT
import static groovyx.net.http.Method.GET


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

def mapFile=new File(new File(local),"mapping.json")

download(url,mapFile.absolutePath)

def json = new JsonSlurper().parse(mapFile)

class Globals {

static int target = 0;
static int real = 0;
static def failedFiles = []
}

downloadFile (json,["com.appdynamics.machineagent:machineagent:?@zip"],"$local/machineagent.zip")

downloadFile (json,["com.appdynamics.controller:controller:?@ear",
					"com.appdynamics.controller:controller-release-ear:?@ear" ]
			,"$local/controller.ear")

downloadFile (json,["com.appdynamics.agent:app-server-agent-obfuscated:?@zip",
					"com.appdynamics.agent:app-server-agent:releaseZip-?@zip"]
			  ,"$local/AppServerAgent.zip")

downloadFile (json,["com.appdynamics.agent:app-server-agent:debugZip-?@zip",
					"com.appdynamics.agent:app-server-agent-dev:?@zip"]
			  ,"$local/AppServerAgentPlain.zip")

downloadFile (json,["com.appdynamics.controller:controller-api:?@jar"],"$local/controller-api.jar")
downloadFile (json,["com.appdynamics.agent:app-server-agent-obfuscated-zkm-changelog:?@txt"],"$local/agentChangelogZKM.txt")
downloadFile (json,["com.appdynamics.controller:controller-zkm-changelog:?@txt"],"$local/controller_zkm.txt");

downloadFile (json,["com.appdynamics.controller:controller-auth:?@jar"],"$local/controller_auth.jar");



if (Globals.target > Globals.real) {
	println "Download Failed for at least one file."
	println "Files scheduled :$Globals.target \n Files success : $Globals.real"
	println "Missing Files :\n - "+Globals.failedFiles.join("\n - ");
	System.exit(-1);
}



def downloadFile(json,ids,filename) {
	Globals.target ++;

	def jsonArtifact = json.artifacts.find {a ->
		def idFound = ids.find { currentId ->
			if (currentId == a?.Id) return currentId 
		}
		if (idFound != null) return a;
	}

	if (jsonArtifact == null) {
		println "ERROR: Couldn't find $filename : Query $ids"
		Globals.failedFiles += [filename]
	} else {
		def file = jsonArtifact.Url
		
		println "Download:  $filename from $file"
		//download(file,filename)
		def target = new File(filename)
		if (target.isFile() ) {
			def md5 = generateMD5(target)
			if (md5 == jsonArtifact.MD5) {
				println "File Exists, skipping"
			} else {
				// reload file because checksumm failed
				download(file,filename)
			}
		} else {
			download(file,filename)
		}

		if (target.isFile() ) {
			def md5 = generateMD5(target)
			if (md5 == jsonArtifact.MD5) {
				Globals.real++;
			} else {
				// reload file because checksumm failed
				println "Download Failed !!!"
				Globals.failedFiles += [filename]
			}
		} else {
			println "Download Failed !!! File Missing !!!"
			Globals.failedFiles += [filename]
		}
	}
}


def download(def url,String filename) {
	download_nativ(url,filename)
}

def download_curl (def url, String filename) {
	println " --> Downloading to local file $filename from \n --< $url"
	
	def proc = "curl -o $filename $url ".execute()

	Thread.start { 
		System.err << proc.err;
		System.out << proc.out;
	} 

	proc.waitFor()


}

def download_nativ (def url, String filename) {
	 long startTime = System.currentTimeMillis();

 println "Downloading to $filename"
	downloadFile(url,new File(filename)) { progress, lastProgress, bytes ->
                    progress = progress as int

                    //only draw every 2 seconds

                    if (progress <= lastProgress) return progress;

                    double pastTime = System.currentTimeMillis()-startTime

                    def kbPerSecond = ((bytes/1024) as double)/(pastTime/1000)

                    def eta = ((pastTime/progress)*(100-progress))/1000 as int
                    //*(100-progress)
                    def f = new DecimalFormat("#,##0.00")
                    printProgress(progress,"Downloading [","] ${f.format(kbPerSecond)} kBytes/s  ETA:$eta sec               ");

                    return progress

                }
    println "Done:"
}


    static def downloadFile(def uri, File destination, Closure callback) {
        def http = new HTTPBuilder(uri);

               
        def result = http.request(GET,ContentType.ANY) { req ->
            response.success = { HttpResponseDecorator resp ->

                destination.withDataOutputStream {DataOutputStream os ->
                    InputStream is = resp.entity.content;
                    def targetSize =  resp.entity.contentLength
                    def buffer = new byte[4096];
                    def readBytes = -1
                    def totalLength = 0
                    def lastCallback
                    while ((readBytes = is.read(buffer)) != -1) {
                        os.write(buffer,0,readBytes);
                        totalLength += readBytes
                        if (targetSize >0) {
                            lastCallback= callback.call((totalLength/targetSize)*100,lastCallback,totalLength);
                        }  else {
                            lastCallback= callback.call(-1,lastCallback,totalLength);
                        }

                    }
                    os.flush()
                    os.close()
                }

            }

            response.failure = { resp, reader ->
                println "Error while generating URL !!!"
                return null;
            }
        }

    }

      static def printProgress(int i, String prefix, String postfix="") {
        String p = "\r"+prefix
        for (int k = 0; k <= 100; k++ ) {
            if (k%20 == 0) {
                p += (k>i)?"   ":"${k}%"
            } else if (k%2 == 0) {
                p += (k>i)?" ":"."
            }
        }
        p+="$postfix"
        print p;

    }

def generateMD5( File file ) {
  def digest = java.security.MessageDigest.getInstance("MD5")
  file.eachByte( 4096 ) { buffer, length ->
    digest.update( buffer, 0, length )
  }
  new BigInteger(1, digest.digest()).toString(16).padLeft(32, '0')
}