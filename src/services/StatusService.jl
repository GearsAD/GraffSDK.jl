using Mocking

statusEndpoint = "api/v0/status"

"""
$(SIGNATURES)
Get the status of the Synchrony service.
"""
function getStatus(config::SynchronyConfig)::String
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
function printStatus(config::SynchronyConfig)::Void
    try
        serviceStatus = getStatus(config)
        print_with_color(:blue, "Synchrony service status: ")
        print_with_color(serviceStatus == "UP!" ? :green : :red, "$(serviceStatus)\r\n")
    catch ex
        println("Unable to get service status, error is:");
        showerror(STDERR, ex, catch_backtrace())
    end
end
