using Mocking

statusEndpoint = "api/v0/status"

"""
$(SIGNATURES)
Get the status of the Synchrony service.
"""
function getStatus()::String
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    url = "$(config.apiEndpoint)/$(statusEndpoint)"
    response = @mock _sendRestRequest(config, HTTP.get, url)
    if(response.status != 200)
        error("Error getting server status, received $(response.status) with body '$(String(response.body))'.")
    end
    return String(response.body)
end

"""
$(SIGNATURES)
Print the current service status.
"""
function printStatus()::Nothing
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    try
        serviceStatus = getStatus()
        printstyled("Synchrony service status: ", color=:blue)
        printstyled("$(serviceStatus)\r\n", color=(serviceStatus == "UP!" ? :green : :red))
    catch ex
        println("Unable to get service status, error is:");
        showerror(stderr, ex, catch_backtrace())
    end
end
