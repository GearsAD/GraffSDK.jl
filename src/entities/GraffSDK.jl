"""
Configuration structure for Synchrony, it defines the Synchrony Web API endpoint and port.
"""
mutable struct SynchronyConfig
    apiEndpoint::String
    accessKey::String
    secretKey::String
    region::String
    userId::String
    robotId::String
    sessionId::String
    SynchronyConfig(apiEndpoint::String, accessKey::String, secretKey::String, region::String, userId::String, robotId::String, sessionId::String) = new(apiEndpoint, accessKey, secretKey, region, userId, robotId, sessionId)
    SynchronyConfig(apiEndpoint::String, accessKey::String, secretKey::String, region::String, userId::String) = new(apiEndpoint, accessKey, secretKey, region, userId, "", "")
end

function show(io::IO, c::SynchronyConfig)
    println(io, "GraffSDK configuration:")
    println(io, " - API endpoint: $(c.apiEndpoint)")
    println(io, " - API Access key: $(c.accessKey)")
    println(io, " - Region: $(c.region)")
    println(io, " - User ID: $(c.userId)")
    println(io, " - Robot ID: $(c.robotId)")
    println(io, " - Session ID: $(c.sessionId)")
end

"""
Standardized error response for any request. This is returned if any requests fail server-side.
"""
struct ErrorResponse
    message::String
    returnCode::Int
end

# The current Graff config.
global __graffConfig = nothing
