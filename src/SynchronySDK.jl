module SynchronySDK

# Imports
using Requests, JSON, Unmarshal
using Formatting

# Includes
include("./entities/SynchronySDK.jl")
include("./entities/Auth.jl")
include("./entities/User.jl")
include("./entities/Session.jl")
include("./entities/Robot.jl")
include("./entities/Cyphon.jl")

# Exports
export SynchronyConfig
export AuthRequest, AuthResponse, authorize, refreshToken
# Internal definitions
authEndpoint = "api/v0/auth"
userEndpoint = "api/v0/users/{1}"
robotsEndpoint = "api/v0/users/{1}/robots/{2}"
sessionsEndpoint = "api/v0/robots/{1}/sessions/{2}"
nodeEndpoint = "api/v0/robots/{1}/sessions/{2}/nodes/{3}"
dataEndpoint = "api/v0/robots/{1}/sessions/{2}/nodes/{3}/bigData/{4}"

# Functions
function authorize(config::SynchronyConfig, authRequest::AuthRequest)::AuthResponse
    url = "$(config.apiEndpoint):$(config.apiPort)/$authEndpoint/authorize"
    @show url
    response = post(url; data=JSON.json(authRequest))
    if(statuscode(response) != 200)
        error("Error authorizing, received $(statuscode(response)) with body '$(readstring(response))'.")
    else
        return Unmarshal.unmarshal(AuthResponse, JSON.parse(readstring(response)))
    end
end

function refreshToken(config::SynchronyConfig, authResponse::AuthResponse)::AuthResponse
    url = "$(config.apiEndpoint):$(config.apiPort)/$authEndpoint/authorize"
    response = post(url; data=JSON.json(authResponse))
    if(statuscode(response) != 200)
        error("Error authorizing, received $(statuscode(response)) with body '$(readstring(response))'.")
    else
        return Unmarshal.unmarshal(AuthResponse, JSON.parse(readstring(response)))
    end
end

end
