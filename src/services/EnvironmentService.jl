environmentsEndpoint = "api/$curApiVersion/environments"
environmentEndpoint = "$environmentsEndpoint/{1}"

"""
$(SIGNATURES)
Gets all environments, if you specify details=true, you also receive associated sessions.
"""
function getEnvironments(;details=false)::Vector{EnvironmentResponse}
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    url = "$(config.apiEndpoint)/$(format(environmentsEndpoint))?details=$(details)"
    response = @mock _sendRestRequest(config, HTTP.get, url)
    if(response.status != 200)
        error("Error getting environments, received $(response.status) with body '$(String(response.body))'.")
    end
    environments = JSON2.read(String(response.body), Vector{EnvironmentResponse})
    # #Sort
    sort!(environments, by=(s -> s.id))
    return environments
end

"""
$(SIGNATURES)
Get a specific environment.
"""
function getEnvironment(envId::String)::EnvironmentResponse
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    url = "$(config.apiEndpoint)/$(format(environmentEndpoint, envId))"
    response = @mock _sendRestRequest(config, HTTP.get, url)
    if(response.status != 200)
        error("Error getting environment, received $(response.status) with body '$(String(response.body))'.")
    end
    return JSON2.read(String(response.body), EnvironmentResponse)
end

"""
$(SIGNATURES)
Delete a specific environment.
Return: Nothing if success, error if failed.
"""
function deleteEnvironment(envId::String)::Nothing
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    url = "$(config.apiEndpoint)/$(format(environmentEndpoint, envId))"
    response = @mock _sendRestRequest(config, HTTP.delete, url)
    if(response.status != 200)
        error("Error deleting environment, received $(response.status) with body '$(String(response.body))'.")
    end
    return nothing
end

"""
$(SIGNATURES)
Create an environment in Graff.
Return: Returns the created environment.
"""
function addEnvironment(environment::EnvironmentRequest)::EnvironmentResponse
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    url = "$(config.apiEndpoint)/$(format(environmentEndpoint, environment.id))"
    body = JSON.json(environment)
    response = @mock _sendRestRequest(config, HTTP.post, url, data=body, headers=Dict{String, String}("Content-Type" => "application/json"))
    if(response.status != 200)
        error("Error creating session, received $(response.status) with body '$(String(response.body))'.")
    end
    body = String(response.body)
    return JSON2.read(body, EnvironmentResponse)
end

"""
$(SIGNATURES)
Bind a session to an environment.
Return: Returns nothing for the moment.
"""
function bindSessionToEnvironment(environment::EnvironmentResponse, session::SessionDetailsResponse)::Nothing
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    url = "$(config.apiEndpoint)/$(format(environmentEndpoint, environment.id))/sessions"
    body = JSON.json(session)
    response = @mock _sendRestRequest(config, HTTP.post, url, data=body, headers=Dict{String, String}("Content-Type" => "application/json"))
    if(response.status != 200)
        error("Error creating session, received $(response.status) with body '$(String(response.body))'.")
    end
    return nothing
    # body = String(response.body)
    # return JSON2.read(body, EnvironmentResponse)
end

"""
$(SIGNATURES)
Unbind a session from an environment.
Return: Returns the updated environment.
"""
function unbindSessionToEnvironment(environment::EnvironmentResponse, session::SessionDetailsResponse)::EnvironmentResponse
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    url = "$(config.apiEndpoint)/$(format(environmentEndpoint, environment.id))/sessions"
    body = JSON.json(session)
    response = @mock _sendRestRequest(config, HTTP.delete, url, data=body, headers=Dict{String, String}("Content-Type" => "application/json"))
    if(response.status != 200)
        error("Error creating session, received $(response.status) with body '$(String(response.body))'.")
    end
    body = String(response.body)
    return JSON2.read(body, EnvironmentResponse)
end

"""
$(SIGNATURES)
Request a multisession solve for a given environment.
Return: Nothing for now - should return a multisessionsolvestatus.
"""
function requestMultisessionSolve(environment::EnvironmentResponse)::Nothing
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    url = "$(config.apiEndpoint)/$(format(environmentEndpoint, environment.id))/solves"
    response = @mock _sendRestRequest(config, HTTP.post, url, headers=Dict{String, String}("Content-Type" => "application/json"))
    if(response.status != 200)
        error("Error creating session, received $(response.status) with body '$(String(response.body))'.")
    end
    # body = String(response.body)
    # return JSON2.read(body, EnvironmentResponse)
    return nothing
end
