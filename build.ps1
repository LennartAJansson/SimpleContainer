$url = "http://buildversionsapi.ubk3s"
$curl = "curl.exe"
$name = "SimpleContainer"

$alive = &${curl} -s "${url}/api/Ping/v1" -H "accept: text/plain"
if($alive -ne """pong""")
{
	"You need to do an initial deploy of BuildVersionsApi"
	"Please run InitBuildVersion.ps1"
	return
}
$json = "{""ProjectName"":""${name}"",""VersionElement"":""Revision""}"
$buildVersion = &${curl} -s -X 'PUT' "${url}/api/BuildVersion/Increment/v1" -H 'accept: application/json' -H 'Content-Type: application/json' -d "$json" | ConvertFrom-Json
$version = $buildVersion.Version

docker build -f .\SimpleContainer\Dockerfile  --force-rm -t registry:5000/simplecontainer:${version} .
docker tag registry:5000/simplecontainer:${version} registry.ubk3s:5000/simplecontainer:${version} 

docker push registry:5000/simplecontainer:${version} 
docker push registry.ubk3s:5000/simplecontainer:${version} 

