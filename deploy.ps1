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

$buildVersion = &${curl} -s "${url}/api/BuildVersion/ReadByName/${name}/v1" | ConvertFrom-Json
$version = $buildVersion.Version

#kustomize edit set image "registry:5000/simplecontainer:${version}"
#kubectl apply -k ./ --kubeconfig $env:kubeconfig
#kubectl apply -k ./ --kubeconfig $env:kubeconfigx
$image = "registry:5000/simplecontainer:${version}"
$cmd = "helm upgrade simplecontainer deployment -n simplecontainer --create-namespace --set image=""${image}"" --set host=""simplecontainer"""
$cmd
Invoke-Expression $cmd
$cmd = "helm upgrade simplecontainer deployment -n simplecontainer --create-namespace --set image=""${image}"" --set host=""simplecontainer.ubk3s""  --kubeconfig ""C:\Users\Lennart\.kube\config.ubk3s"""
$cmd
Invoke-Expression $cmd
