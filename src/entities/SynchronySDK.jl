"""
Configuration structure for Synchrony, it defines the Synchrony Web API endpoint and port.
"""
struct SynchronyConfig
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

"""
Standardized error response for any request. This is returned if any requests fail server-side.
"""
struct ErrorResponse
    message::String
    returnCode::Int
end
