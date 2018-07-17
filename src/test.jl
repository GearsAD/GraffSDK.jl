using SynchronySDK
using HTTP

# Should fail
url = "https://qxzjrc6f93.execute-api.us-east-2.amazonaws.com/DEV/api/v0/status"
response = get(url; headers = Dict())
@show response

# Get a configuration
println(" - Retrieving Synchrony Configuration...")
cd(joinpath(Pkg.dir("SynchronySDK"),"examples"))
configFile = open("synchronyConfig_NaviEast_DEV.json")
configData = JSON.parse(readstring(configFile))
close(configFile)
synchronyConfig = Unmarshal.unmarshal(SynchronyConfig, configData)

HTTP.get(url;
    aws_authorization=true,
    aws_service="execute-api",
    aws_region=synchronyConfig.region,
    aws_access_key_id=synchronyConfig.accessKey,
    aws_secret_access_key=synchronyConfig.secretKey)

url = "https://qxzjrc6f93.execute-api.us-east-2.amazonaws.com/DEV/api/v0/users/NewUser42"


"""
$SIGNATURES
Produces the authorization and sends the REST request.
"""
function _sendRestRequest(synchronyConfig::SynchronyConfig, verbFunction, url::String; data::String="", headers::Dict{String, String}=Dict{String, String}(), debug::Bool=false)::Requests.Response
    env = AWSEnv(; id=synchronyConfig.accessKey, key=synchronyConfig.secretKey, region=synchronyConfig.region, ep=url, dbg=debug)
    # Force the region as we are using a custom endpoint
    env.region = synchronyConfig.region

    if data != ""
        HTTP.get(url;
            aws_authorization=true,
            aws_service="execute-api",
            aws_region=synchronyConfig.region,
            aws_access_key_id=synchronyConfig.accessKey,
            aws_secret_access_key=synchronyConfig.secretKey)

        return verbFunction(url;
            aws_authorization=true,
            aws_service="execute-api",
            aws_region=synchronyConfig.region,
            aws_access_key_id=synchronyConfig.accessKey,
            aws_secret_access_key=synchronyConfig.secretKey)
    end
    return verbFunction(url, headers = headers)
end
