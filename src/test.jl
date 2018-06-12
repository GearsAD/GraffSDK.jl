using SynchronySDK
using AWS

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

# Testing my method.
# _sendRestRequest(synchronyConfig, Requests.get, "https://qxzjrc6f93.execute-api.us-east-2.amazonaws.com/DEV/api/v0/status", debug=true)
getStatus(synchronyConfig)
getUser(synchronyConfig, "NewUser")

"""
$SIGNATURES
Produces the authorization and sends the REST request.
"""
function _sendRestRequest2(synchronyConfig::SynchronyConfig, verbFunction, url::String; data::String="", headers::Dict{String, String}=Dict{String, String}(), debug::Bool=false)::Requests.Response
    env = AWSEnv(; id=synchronyConfig.accessKey, key=synchronyConfig.secretKey, region=synchronyConfig.region, ep=url, dbg=debug)
    # Force the region as we are using a custom endpoint
    env.region = synchronyConfig.region

    # Get the auth headers
    amz_headers, amz_data, signed_querystr = signature_version_4(env, "execute-api", true, deepcopy(data))
    # amz_headers, amz_data, signed_querystr = canonicalize_and_sign(env, "execute-api", true, Vector{Tuple}())
    for val in amz_headers
        headers[val[1]] = val[2]
    end

    if data != ""
        return verbFunction(url, headers = headers, data = data)
    end
    return verbFunction(url, headers = headers)
end

using AWS.S3
using AWS.Crypto

url = "https://qxzjrc6f93.execute-api.us-east-2.amazonaws.com/DEV/api/v0/users/NewUser234"
newUser = UserRequest("NewUser234", "NewUser234", "email@email.com", "N/A", "Student", "Student", string(Base.Random.uuid4()))
_sendRestRequest2(synchronyConfig, Requests.post, url, debug=true)

# addUser(synchronyConfig, newUser)
