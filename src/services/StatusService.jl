using Mocking

statusEndpoint = "api/v0/status"

"""
$(SIGNATURES)
Get the status of the Synchrony service.
"""
function getStatus(config::SynchronyConfig)::String
    url = "$(config.apiEndpoint)/$(statusEndpoint)"
    response = @mock _sendRestRequest(config, Requests.get, url)
    if(statuscode(response) != 200)
        error("Error getting server status, received $(statuscode(response)) with body '$(readstring(response))'.")
    end
    return readstring(response)
end
