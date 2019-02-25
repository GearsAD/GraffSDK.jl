sessionsEndpoint = "api/$curApiVersion/users/{1}/robots/{2}/sessions"
sessionEndpoint = "api/$curApiVersion/users/{1}/robots/{2}/sessions/{3}"
variablesEndpoint = "api/$curApiVersion/users/{1}/robots/{2}/sessions/{3}/variables"
variableLabelledEndpoint = "$variablesEndpoint/labelled/{4}"
variableEndpoint = "$variablesEndpoint/{4}"
factorsEndpoint = "api/$curApiVersion/users/{1}/robots/{2}/sessions/{3}/factors"
factorEndpoint = "$factorsEndpoint/{4}"
bigDataEndpoint = "$variablesEndpoint/{4}/data"
bigDataElementEndpoint = "$bigDataEndpoint/{5}"
bigDataRawElementEndpoint = "$bigDataEndpoint/{5}/raw"
sessionReadyEndpoint = "api/$curApiVersion/users/{1}/robots/{2}/sessions/{3}/ready/{4}"

odoEndpoint = "api/v0/users/{1}/robots/{2}/sessions/{3}/odometry"
sessionSolveEndpoint = "api/v0/users/{1}/robots/{2}/sessions/{3}/solve"
sessionQueueLengthEndpoint = "api/v0/users/{1}/robots/{2}/sessions/{3}/queue/status"
sessionDeadQueueLengthEndpoint = "api/v0/users/{1}/robots/{2}/sessions/{3}/queue/dead"
sessionExportJldEndpoint = "api/v0/users/{1}/robots/{2}/sessions/{3}/export/jld"
bearingRangeEndpoint = "api/v0/users/{1}/robots/{2}/sessions/{3}/factors/bearingrange"

"""
$(SIGNATURES)
Gets all sessions for the current robot.
Return: A vector of sessions for the current robot.
"""
function getSessions(robotId::String;details=false)::Vector{SessionDetailsResponse}
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    url = "$(config.apiEndpoint)/$(format(sessionsEndpoint, config.userId, robotId))?details=$(details)"
    response = @mock _sendRestRequest(config, HTTP.get, url)
    if(response.status != 200)
        error("Error getting sessions, received $(response.status) with body '$(String(response.body))'.")
    end
    sessions = JSON2.read(String(response.body), Vector{SessionDetailsResponse})
    # #Sort
    sort!(sessions, by=(s -> s.id))
    return sessions
end

"""
$(SIGNATURES)
Gets all sessions for the current robot.
Return: A vector of sessions for the current robot.
"""
function getSessions(;details=false)::Vector{SessionDetailsResponse}

    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    if config.robotId == ""
        error("Your config doesn't have a robot specified, please attach your config to a valid robot by setting the robotId field. Robot = $(config.robotId)")
    end

    return getSessions(config.robotId)
end

"""
$(SIGNATURES)
Return: Returns true if the session exists already.
"""
function isSessionExisting(robotId::String, sessionId::String)::Bool
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end

    url = "$(config.apiEndpoint)/$(format(sessionEndpoint, config.userId, robotId, sessionId))/exists"
    response = @mock _sendRestRequest(config, HTTP.get, url)
    body = String(response.body)
    if(response.status != 200)
        error("Error getting session existence, received $(response.status) with body '$body'.")
    end
    return lowercase(body) == "true"
end

"""
$(SIGNATURES)
Return: Returns true if the session exists already.
"""
function isSessionExisting(sessionId::String)::Bool
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    if config.robotId == ""
        error("Your config doesn't have a robot specified, please attach your config to a valid robot or session by setting the robotId and sessionId fields. Robot = $(config.robotId), Session = $(config.sessionId)")
    end

    return isSessionExisting(config.robotId, sessionId)
end

"""
$(SIGNATURES)
Return: Returns true if the session exists already.
"""
function isSessionExisting()::Bool
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    if config.robotId == "" || config.sessionId == ""
        error("Your config doesn't have a robot or a session specified, please attach your config to a valid robot or session by setting the robotId and sessionId fields. Robot = $(config.robotId), Session = $(config.sessionId)")
    end

    return isSessionExisting(config.robotId, config.sessionId)
end

"""
$(SIGNATURES)
Get a specific session given a user ID, robot ID, and session ID.
Return: The session details for the provided user ID, robot ID, and session ID.
"""
function getSession(robotId::String, sessionId::String)::SessionDetailsResponse
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    url = "$(config.apiEndpoint)/$(format(sessionEndpoint, config.userId, robotId, sessionId))"
    response = @mock _sendRestRequest(config, HTTP.get, url)
    if(response.status != 200)
        error("Error getting session, received $(response.status) with body '$(String(response.body))'.")
    end
    return JSON2.read(String(response.body), SessionDetailsResponse)
end

"""
$(SIGNATURES)
Get a specific session given a session response (update).
Return: The session details for the provided user ID, robot ID, and session ID.
"""
function getSession(session::SessionDetailsResponse)::SessionDetailsResponse
    return getSession(session.robotId, session.id)
end

"""
$(SIGNATURES)
Get a specific session given a user ID, robot ID, and session ID.
Return: The session details for the provided user ID, robot ID, and session ID.
"""
function getSession()::SessionDetailsResponse
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    if config.robotId == "" || config.sessionId == ""
        error("Your config doesn't have a robot or a session specified, please attach your config to a valid robot or session by setting the robotId and sessionId fields. Robot = $(config.robotId), Session = $(config.sessionId)")
    end

    return getSession(config.robotId, config.sessionId)
end

"""
$(SIGNATURES)
Delete a specific session given a user ID, robot ID, and session ID.
Return: Nothing if success, error if failed.
"""
function deleteSession(robotId::String, sessionId::String)::Nothing
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    url = "$(config.apiEndpoint)/$(format(sessionEndpoint, config.userId, robotId, sessionId))"
    response = @mock _sendRestRequest(config, HTTP.delete, url)
    if(response.status != 200)
        error("Error deleting session, received $(response.status) with body '$(String(response.body))'.")
    end
    return nothing
end

"""
$(SIGNATURES)
Delete a specific session given a session response.
Return: Nothing if success, error if failed.
"""
function deleteSession(session::SessionDetailsResponse)::Nothing
    return deleteSession(session.robotId, session.id)
end

"""
$(SIGNATURES)
Delete a specific session given a user ID, robot ID, and session ID.
Return: Nothing if success, error if failed.
"""
function deleteSession()::Nothing
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    if config.robotId == "" || config.sessionId == ""
        error("Your config doesn't have a robot or a session specified, please attach your config to a valid robot or session by setting the robotId and sessionId fields. Robot = $(config.robotId), Session = $(config.sessionId)")
    end

    return deleteSession(config.robotId, config.sessionId)
end


"""
$(SIGNATURES)
Create a session in Synchrony and associate it with the given robot+user.
Return: Returns the created session.
"""
function addSession(robotId::String, session::SessionDetailsRequest)::SessionDetailsResponse
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    url = "$(config.apiEndpoint)/$(format(sessionEndpoint, config.userId, robotId, session.id))"
    body = JSON.json(session)
    response = @mock _sendRestRequest(config, HTTP.post, url, data=body, headers=Dict{String, String}("Content-Type" => "application/json"))
    if(response.status != 200)
        error("Error creating session, received $(response.status) with body '$(String(response.body))'.")
    end
    body = String(response.body)
    return JSON2.read(body, SessionDetailsResponse)
end

"""
$(SIGNATURES)
Create a session in Synchrony and associate it with the given robot+user.
Return: Returns the created session.
"""
function addSession(session::SessionDetailsRequest)::SessionDetailsResponse
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    if config.robotId == ""
        error("Your config doesn't have a robot specified, please attach your config to a valid robot by setting the robotId fields. Robot = $(config.robotId)")
    end

    return addSession(config.robotId, session)
end

"""
$(SIGNATURES)
Gets all nodes for a given session.
Return: A vector of nodes for a given robot.
"""
function getVariables(robotId::String, sessionId::String; details=false)::Vector{NodeResponse}
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    url = "$(config.apiEndpoint)/$(format(variablesEndpoint, config.userId, robotId, sessionId))$(details ? "?details=true" : "")"
    response = @mock _sendRestRequest(config, HTTP.get, url)
    if(response.status != 200)
        error("Error getting sessions, received $(response.status) with body '$(String(response.body))'.")
    end
    body = String(response.body)
    nodes = JSON2.read(body, Vector{NodeResponse})

    # sort!(nodes; by=(n -> n.label))
    return nodes
end

"""
$(SIGNATURES)
Gets all nodes for a given session.
Return: A vector of nodes for a given robot.
"""
function getVariables(;details=false)::Vector{NodeResponse}
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    if config.robotId == "" || config.sessionId == ""
        error("Your config doesn't have a robot or a session specified, please attach your config to a valid robot or session by setting the robotId and sessionId fields. Robot = $(config.robotId), Session = $(config.sessionId)")
    end

    return getVariables(config.robotId, config.sessionId; details=details)
end

"""
$(SIGNATURES)
Gets all nodes for a given session.
Return: A vector of nodes for a given robot.
Alias for convenience.
"""
function ls(;details=false)::Vector{NodeResponse}
    return getVariables(details=details)
end

"""
$(SIGNATURES)
Get data entries for whole session.
Return: Summary of all data associated with a session as a dictionary keyed by label ID.
"""
function getSessionDataEntries(robotId::String, sessionId::String)::Dict{String, Vector{BigDataEntryResponse}}
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end

    url = "$(config.apiEndpoint)/$(format(sessionEndpoint, config.userId, robotId, sessionId))/dataentries"
    response = @mock _sendRestRequest(config, HTTP.get, url)
    body = String(response.body)
    if(response.status != 200)
        error("Error data entries for session, received $(response.status) with body '$body'.")
    else
        bigDataEntries = JSON2.read(body, Dict{String, Vector{BigDataEntryResponse}})
        return bigDataEntries
    end
end

"""
$(SIGNATURES)
Get data entries for whole session.
Return: Summary of all data associated with a session as a dictionary keyed by label ID.
"""
function getSessionDataEntries()::Dict{String, Vector{BigDataEntryResponse}}
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    if config.robotId == "" || config.sessionId == ""
        error("Your config doesn't have a robot or a session specified, please attach your config to a valid robot or session by setting the robotId and sessionId fields. Robot = $(config.robotId), Session = $(config.sessionId)")
    end

    return getSessionDataEntries(config.robotId, config.sessionId)
end

"""
$(SIGNATURES)
Gets a node's details by either its ID or name.
Return: A node's details.
"""
function getVariable(robotId::String, sessionId::String, nodeIdOrLabel::Union{Int, String, Symbol})::NodeDetailsResponse
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    url = "$(config.apiEndpoint)/$(format(variableEndpoint, config.userId, robotId, sessionId, nodeIdOrLabel))"
    if(typeof(nodeIdOrLabel) in [String, Symbol])
        nodeIdOrLabel = String(nodeIdOrLabel)
        url = "$(config.apiEndpoint)/$(format(variableLabelledEndpoint, config.userId, robotId, sessionId, nodeIdOrLabel))"
    end
    response = @mock _sendRestRequest(config, HTTP.get, url)
    if(response.status != 200)
        error("Error getting node, received $(response.status) with body '$(String(response.body))'.")
    end
    body = String(response.body)
    # Some manual effort done
    node = JSON2.read(body, NodeDetailsResponse)
    return node
end

"""
$(SIGNATURES)
Gets a node's details by either its ID or name.
Return: A node's details.
"""
function getVariable(nodeIdOrLabel::Union{Int, String, Symbol})::NodeDetailsResponse
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    if config.robotId == "" || config.sessionId == ""
        error("Your config doesn't have a robot or a session specified, please attach your config to a valid robot or session by setting the robotId and sessionId fields. Robot = $(config.robotId), Session = $(config.sessionId)")
    end

    return getVariable(config.robotId, config.sessionId, nodeIdOrLabel)
end

"""
$(SIGNATURES)
Set the ready status for a session.
"""
function putReady(robotId::String, sessionId::String, isReady::Bool)::Nothing
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    url = "$(config.apiEndpoint)/$(format(sessionReadyEndpoint, config.userId, robotId, sessionId, isReady))"
    response = @mock _sendRestRequest(config, HTTP.put, url, data="")
    if(response.status != 200)
        error("Error updating the ready status of the session, received $(response.status) with body '$(String(response.body))'.")
    end
    return nothing
end

"""
$(SIGNATURES)
Set the ready status for a session.
"""
function putReady(isReady::Bool)::Nothing
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    if config.robotId == "" || config.sessionId == ""
        error("Your config doesn't have a robot or a session specified, please attach your config to a valid robot or session by setting the robotId and sessionId fields. Robot = $(config.robotId), Session = $(config.sessionId)")
    end

    return putReady(config.robotId, config.sessionId, isReady)
end

"""
$(SIGNATURES)
Manually request that the session is solved in entirety (update whole session).
"""
function requestSessionSolve(robotId::String, sessionId::String)::Nothing
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    url = "$(config.apiEndpoint)/$(format(sessionSolveEndpoint, config.userId, robotId, sessionId))"
    response = @mock _sendRestRequest(config, HTTP.put, url, data="")
    if(response.status != 200)
        error("Error manually requesting a session solve, received $(response.status) with body '$(String(response.body))'.")
    end
    return nothing
end

"""
$(SIGNATURES)
Request that the session is solved in entirety (update whole session).
"""
function requestSessionSolve()::Nothing
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    if config.robotId == "" || config.sessionId == ""
        error("Your config doesn't have a robot or a session specified, please attach your config to a valid robot or session by setting the robotId and sessionId fields. Robot = $(config.robotId), Session = $(config.sessionId)")
    end

    return requestSessionSolve(config.robotId, config.sessionId)
end


"""
$(SIGNATURES)
Create a variable in Synchrony.
Return: Returns the ID+label of the created variable.
"""
function addVariable(robotId::String, sessionId::String, variableRequest::VariableRequest)::Nothing
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    url = "$(config.apiEndpoint)/$(format(variableEndpoint, config.userId, robotId, sessionId, variableRequest.label))"
    response = @mock _sendRestRequest(config, HTTP.post, url, data=JSON.json(variableRequest), headers=Dict{String, String}("Content-Type" => "application/json"))
    if(response.status != 200)
        error("Error creating variable, received $(response.status) with body '$(String(response.body))'.")
    end
    return nothing
    # return _unmarshallWithLinks(String(response.body), NodeResponse)
end

"""
$(SIGNATURES)
Create a variable in Synchrony.
Return: Returns the ID+label of the created variable.
"""
function addVariable(variableRequest::VariableRequest)::Nothing
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    if config.robotId == "" || config.sessionId == ""
        error("Your config doesn't have a robot or a session specified, please attach your config to a valid robot or session by setting the robotId and sessionId fields. Robot = $(config.robotId), Session = $(config.sessionId)")
    end

    return addVariable(config.robotId, config.sessionId,variableRequest)
end

"""
$(SIGNATURES)
Create a variable in Synchrony.
Return: Returns the ID+label of the created variable.
"""
function addVariable(label::String, varType::String, additionalLabels::Vector{String}=Vector{String}())::Nothing
    return addVariable(VariableRequest(label, varType, additionalLabels))
end

"""
$(SIGNATURES)
Create a variable in Synchrony.
Return: Returns the ID+label of the created variable.
"""
function addVariable(label::Symbol, varType::Type, additionalLabels::Vector{String}=Vector{String}())::Nothing
    return addVariable(VariableRequest(String(label), string(varType), additionalLabels))
end


"""
$(SIGNATURES)
Create a variable in Graff.
"""
function addVariable(config::GraffConfig, variableRequest::VariableRequest)

    if config.robotId == "" || config.sessionId == ""
        error("Your config doesn't have a robot or a session specified, please attach your config to a valid robot or session by setting the robotId and sessionId fields. Robot = $(config.robotId), Session = $(config.sessionId)")
    end

    return addVariable(config.robotId, config.sessionId, variableRequest)
end

"""
$(SIGNATURES)
Create a variable in Graff.
"""
function addVariable(config::GraffConfig, label::String, varType::String, additionalLabels::Vector{String}=Vector{String}())::Nothing
    return addVariable(config,VariableRequest(label, varType, additionalLabels))
end

"""
$(SIGNATURES)
Create a variable in Graff.
"""
function addVariable(config::GraffConfig, label::Symbol, varType::Type, additionalLabels::Vector{String}=Vector{String}())::Nothing
    return addVariable(config, VariableRequest(String(label), string(varType), additionalLabels))
end



"""
$(SIGNATURES)
Create a factor in Graff.
"""
function addFactor(config::GraffConfig, factorRequest::FactorRequest)::Nothing
    if config.robotId == "" || config.sessionId == ""
        error("Your config doesn't have a robot or a session specified, please attach your config to a valid robot or session by setting the robotId and sessionId fields. Robot = $(config.robotId), Session = $(config.sessionId)")
    end
    url = "$(config.apiEndpoint)/$(format(factorsEndpoint, config.userId, config.robotId, config.sessionId))"
    response = @mock _sendRestRequest(config, HTTP.post, url, data=JSON.json(factorRequest), headers=Dict{String, String}("Content-Type" => "application/json"))
    if (response.status != 200)
        error("Error creating factor, received $(response.status) with body '$(String(response.body))'.")
    end
    return nothing
    # return _unmarshallWithLinks(String(response.body), NodeResponse)
end


"""
$(SIGNATURES)
Create a factor in Graff as you do in RoME.
Return: Returns the ID+label of the created factor.
"""
function addFactor(config::GraffConfig, variables::Vector{Symbol}, romeFactor)::Nothing

    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    if config.robotId == "" || config.sessionId == ""
        error("Your config doesn't have a robot or a session specified, please attach your config to a valid robot or session by setting the robotId and sessionId fields. Robot = $(config.robotId), Session = $(config.sessionId)")
    end

    try
        # Try pack quickly here.
        fctType = typeof(romeFactor).name # Simply 'prior', as example
        fctPackedType = getfield(Main, Symbol("Packed$(fctType)") )#eval(Meta.parse("Packed$(fctType)"))
        @info "Trying to encode factor $fctType into PackedType $fctPackedType..."
        fctRequest = FactorRequest(String.(variables), string(fctType), convert(fctPackedType, romeFactor))
        @info "Successfully encoded - sending to Graff..."
        return addFactor(config, fctRequest)
    catch ex
        @info "Unable to pack and send factor - did you include RoME and/or Caesar? Please check your factor type is valid and has a PackedType."
        showerror(stderr, ex, catch_backtrace())
        error(ex)
    end
end

"""
$(SIGNATURES)
Create a factor in Synchrony.
Return: Returns the ID+label of the created factor.
"""
function addFactor(robotId::String, sessionId::String, factorRequest::FactorRequest)::Nothing
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    url = "$(config.apiEndpoint)/$(format(factorsEndpoint, config.userId, robotId, sessionId))"
    response = @mock _sendRestRequest(config, HTTP.post, url, data=JSON.json(factorRequest), headers=Dict{String, String}("Content-Type" => "application/json"))
    if (response.status != 200)
        error("Error creating factor, received $(response.status) with body '$(String(response.body))'.")
    end
    return nothing
    # return _unmarshallWithLinks(String(response.body), NodeResponse)
end

"""
$(SIGNATURES)
Create a factor in Synchrony.
Return: Returns the ID+label of the created factor.
"""
function addFactor(factorRequest::FactorRequest)::Nothing
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    if config.robotId == "" || config.sessionId == ""
        error("Your config doesn't have a robot or a session specified, please attach your config to a valid robot or session by setting the robotId and sessionId fields. Robot = $(config.robotId), Session = $(config.sessionId)")
    end

    return addFactor(config.robotId, config.sessionId, factorRequest)
end

"""
$(SIGNATURES)
Create a factor in Graff as you do in RoME.
Return: Returns the ID+label of the created factor.
"""
function addFactor(variables::Vector{Symbol}, romeFactor)::Nothing
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    if config.robotId == "" || config.sessionId == ""
        error("Your config doesn't have a robot or a session specified, please attach your config to a valid robot or session by setting the robotId and sessionId fields. Robot = $(config.robotId), Session = $(config.sessionId)")
    end

    try
        # Try pack quickly here.
        fctType = typeof(romeFactor).name # Simply 'prior', as example
        fctPackedType = getfield(Main, Symbol("Packed$(fctType)") )#eval(Meta.parse("Packed$(fctType)"))
        @info "Trying to encode factor $fctType into PackedType $fctPackedType..."
        fctRequest = FactorRequest(String.(variables), string(fctType), convert(fctPackedType, romeFactor))
        @info "Successfully encoded - sending to Graff..."
        return addFactor(config.robotId, config.sessionId, fctRequest)
    catch ex
        @info "Unable to pack and send factor - did you include RoME and/or Caesar? Please check your factor type is valid and has a PackedType."
        showerror(stderr, ex, catch_backtrace())
        error(ex)
    end
end

"""
$(SIGNATURES)
Create a variable in Synchrony and associate it with the given robot+user.
Return: Returns ID+label of the created factor.
"""
function addBearingRangeFactor(robotId::String, sessionId::String, bearingRangeRequest::BearingRangeRequest)::Nothing
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    url = "$(config.apiEndpoint)/$(format(bearingRangeEndpoint, config.userId, robotId, sessionId))"
    response = @mock _sendRestRequest(config, HTTP.post, url, data=JSON.json(bearingRangeRequest), headers=Dict{String, String}("Content-Type" => "application/json"))
    if(response.status != 200)
        error("Error creating bearing range factor, received $(response.status) with body '$(String(response.body))'.")
    end
    return nothing
    # return _unmarshallWithLinks(String(response.body), NodeResponse)
end

"""
$(SIGNATURES)
Create a variable in Synchrony and associate it with the given robot+user.
Return: Returns ID+label of the created factor.
"""
function addBearingRangeFactor(bearingRangeRequest::BearingRangeRequest)::Nothing
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    if config.robotId == "" || config.sessionId == ""
        error("Your config doesn't have a robot or a session specified, please attach your config to a valid robot or session by setting the robotId and sessionId fields. Robot = $(config.robotId), Session = $(config.sessionId)")
    end

    return addBearingRangeFactor(config.robotId, config.sessionId, bearingRangeRequest)
end

"""
$(SIGNATURES)
Create a session in Synchrony and associate it with the given robot+user.
Return: Returns the added odometry information.
"""
function addOdometryMeasurement(robotId::String, sessionId::String, addOdoRequest::AddOdometryRequest)::Nothing
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    url = "$(config.apiEndpoint)/$(format(odoEndpoint, config.userId, robotId, sessionId))"
    response = @mock _sendRestRequest(config, HTTP.post, url, data=JSON.json(addOdoRequest), headers=Dict{String, String}("Content-Type" => "application/json"))
    if(response.status != 200)
        error("Error creating odometry, received $(response.status) with body '$(String(response.body))'.")
    end
    return nothing
end

"""
$(SIGNATURES)
Create a session in Synchrony and associate it with the given robot+user.
Return: Returns the added odometry information.
"""
function addOdometryMeasurement(addOdoRequest::AddOdometryRequest)::Nothing
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    if config.robotId == "" || config.sessionId == ""
        error("Your config doesn't have a robot or a session specified, please attach your config to a valid robot or session by setting the robotId and sessionId fields. Robot = $(config.robotId), Session = $(config.sessionId)")
    end

    return addOdometryMeasurement(config.robotId, config.sessionId, addOdoRequest)
end


"""
$(SIGNATURES)
Create a session in Synchrony and associate it with the given robot+user.
Return: Returns the added odometry information.
"""
function addOdometryMeasurement(odoDelta::Vector{Float64}, pOdo::Matrix{Float64})::Nothing
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    if config.robotId == "" || config.sessionId == ""
        error("Your config doesn't have a robot or a session specified, please attach your config to a valid robot or session by setting the robotId and sessionId fields. Robot = $(config.robotId), Session = $(config.sessionId)")
    end

    return addOdometryMeasurement(config.robotId, config.sessionId, AddOdometryRequest(odoDelta, pOdo))
end

"""
$(SIGNATURES)
Get data entries associated with a node.
Return: Summary of all data associated with a node.
"""
function getDataEntries(robotId::String, sessionId::String, node::Union{Int, NodeResponse, NodeDetailsResponse})::Vector{BigDataEntryResponse}
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    # Get the node ID.
    nodeId = typeof(node) != Int ? node.id : node;

    url = "$(config.apiEndpoint)/$(format(bigDataEndpoint, config.userId, robotId, sessionId, nodeId))"
    response = @mock _sendRestRequest(config, HTTP.get, url)
    if(response.status != 200)
        error("Error getting node data entries, received $(response.status) with body '$(String(response.body))'.")
    else
        datas = JSON2.read(String(response.body), Vector{BigDataEntryResponse})
        sort(datas; by=(d -> d.id))
        return datas
    end
end

"""
$(SIGNATURES)
Get data entries associated with a node.
Return: Summary of all data associated with a node.
"""
function getDataEntries(node::Union{Int, NodeResponse, NodeDetailsResponse})::Vector{BigDataEntryResponse}
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    if config.robotId == "" || config.sessionId == ""
        error("Your config doesn't have a robot or a session specified, please attach your config to a valid robot or session by setting the robotId and sessionId fields. Robot = $(config.robotId), Session = $(config.sessionId)")
    end

    return getDataEntries(config.robotId, config.sessionId, node)
end

"""
$(SIGNATURES)
Get data elment associated with a node.
Return: Full data element associated with the specified node.
"""
function getData(robotId::String, sessionId::String, node::Union{Int, NodeResponse, NodeDetailsResponse}, bigDataKey::Union{String, BigDataEntryResponse})::Union{BigDataElementResponse, Nothing}
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    # Get the node ID.
    nodeId = typeof(node) != Int ? node.id : node;
    bigDataKey = typeof(bigDataKey) == BigDataEntryResponse ? bigDataKey.id : bigDataKey

    # Check if caching enabled,
    if isdefined(GraffSDK, :__localCache)
        cacheKey = "$(config.userId)|$robotId|$sessionId|$nodeId|$bigDataKey"
        @debug "Looking in cache for '$cacheKey'..."
        elem = getElement(cacheKey)
        elem != nothing && @info "Found in cache!"
        if __forceOnlyLocalCache
            elem == nothing && @warn "Element doesn't exist in local cache and forceOnlyLocalCache is true, so returning nothing!"
            return elem
        end
        # Otherwise if cache hit, return it.
        elem != nothing  && return elem
        @debug "Cache miss - retrieving from global server..."
    end

    url = "$(config.apiEndpoint)/$(format(bigDataElementEndpoint, config.userId, robotId, sessionId, nodeId, bigDataKey))"
    response = @mock _sendRestRequest(config, HTTP.get, url)
    if(response.status != 200)
        error("Error getting node data entries, received $(response.status) with body '$(String(response.body))'.")
    end
    bde = _unmarshallWithLinks(String(response.body), BigDataElementResponse)
    # Update the cache
    if isdefined(GraffSDK, :__localCache)
        @debug "Updating cache..."
        setElement("$(config.userId)|$robotId|$sessionId|$nodeId|$bigDataKey", bde)
    end
    return bde
end

"""
$(SIGNATURES)
Get data elment associated with a node.
Return: Full data element associated with the specified node.
"""
function getData(node::Union{Int, NodeResponse, NodeDetailsResponse}, bigDataKey::Union{String, BigDataEntryResponse})::Union{BigDataElementResponse, Nothing}
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    if config.robotId == "" || config.sessionId == ""
        error("Your config doesn't have a robot or a session specified, please attach your config to a valid robot or session by setting the robotId and sessionId fields. Robot = $(config.robotId), Session = $(config.sessionId)")
    end

    return getData(config.robotId, config.sessionId, node, bigDataKey)
end

"""
$(SIGNATURES)
Get data elment associated with a node.
Return: Full data element associated with the specified node.
"""
function getRawData(robotId::String, sessionId::String, node::Union{Int, NodeResponse, NodeDetailsResponse}, bigDataKey::Union{String, BigDataEntryResponse})::String
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    # Get the node ID.
    nodeId = typeof(node) != Int ? node.id : node;
    bigDataKey = typeof(bigDataKey) == BigDataEntryResponse ? bigDataKey.id : bigDataKey

    url = "$(config.apiEndpoint)/$(format(bigDataRawElementEndpoint, config.userId, robotId, sessionId, nodeId, bigDataKey))"
    response = @mock _sendRestRequest(config, HTTP.get, url)
    if(response.status != 200)
        error("Error getting node data entries, received $(response.status) with body '$(String(response.body))'.")
    end
    return String(response.body)
end

"""
$(SIGNATURES)
Get data elment associated with a node.
Return: Full data element associated with the specified node.
"""
function getRawData(node::Union{Int, NodeResponse, NodeDetailsResponse}, bigDataKey::Union{String, BigDataEntryResponse})::String
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    if config.robotId == "" || config.sessionId == ""
        error("Your config doesn't have a robot or a session specified, please attach your config to a valid robot or session by setting the robotId and sessionId fields. Robot = $(config.robotId), Session = $(config.sessionId)")
    end

    return getRawData(config.robotId, config.sessionId, node, bigDataKey)
end

"""
$(SIGNATURES)
Add a data element associated with a node.
Return: Nothing if succeed, error if failed.
"""
function setData(robotId::String, sessionId::String, node::Union{Int, String, Symbol, NodeResponse, NodeDetailsResponse}, bigDataElement::BigDataElementRequest)::Nothing
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    # Get the node ID.
    nodeId = typeof(node) == NodeResponse || typeof(node) == NodeDetailsResponse ? node.id : node;
    nodeId = typeof(nodeId) == Symbol ? String(nodeId) : nodeId;

    tempData = bigDataElement.data
    if __forceOnlyLocalCache # Emtpy out the data if it's only going local.
        @debug "Cleaning out data because forcing local cache, only saving entry..."
        bigDataElement = deepcopy(bigDataElement)
        bigDataElement.data = ""
    end

    url = "$(config.apiEndpoint)/$(format(bigDataElementEndpoint, config.userId, robotId, sessionId, nodeId, bigDataElement.id))"
    response = @mock _sendRestRequest(config, HTTP.post, url, data=JSON.json(bigDataElement), headers=Dict{String, String}("Content-Type" => "application/json"))
    if(response.status != 200)
        error("Error adding data element, received $(response.status) with body '$(String(response.body))'.")
    end

    # TODO: Return the data entry when setting...
    # Update the cache
    if isdefined(GraffSDK, :__localCache)
        cacheKey = "$(config.userId)|$robotId|$sessionId|$nodeId|$(bigDataElement.id)"
        @debug "Updating cache key '$cacheKey'..."
        bde = BigDataElementResponse(bigDataElement.id, "LOCAL_CACHE", nothing, bigDataElement.sourceName, bigDataElement.description, bigDataElement.data, bigDataElement.mimeType, string(now), Dict{String, String}())
        if __forceOnlyLocalCache
            bde.data = tempData
        end
        setElement(cacheKey, bde)
    end

    return nothing
end

"""
$(SIGNATURES)
Set a data element associated with a node.
Return: Nothing if succeed, error if failed.
"""
function setData(node::Union{Int, String, Symbol, NodeResponse, NodeDetailsResponse}, bigDataElement::BigDataElementRequest)::Nothing
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    if config.robotId == "" || config.sessionId == ""
        error("Your config doesn't have a robot or a session specified, please attach your config to a valid robot or session by setting the robotId and sessionId fields. Robot = $(config.robotId), Session = $(config.sessionId)")
    end

    return setData(config.robotId, config.sessionId, node, bigDataElement)
end

"""
$(SIGNATURES)
Set a data element associated with a node.
Return: Nothing if succeed, error if failed.
"""
function setData(node::Union{Int, String, Symbol, NodeResponse, NodeDetailsResponse}, elemId::String, data::String; sourceName::String="mongo", description::String="", mimeType::String="application/octet-stream")::Nothing
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    if config.robotId == "" || config.sessionId == ""
        error("Your config doesn't have a robot or a session specified, please attach your config to a valid robot or session by setting the robotId and sessionId fields. Robot = $(config.robotId), Session = $(config.sessionId)")
    end

    de = BigDataElementRequest(elemId, sourceName, description, data, mimeType)
    return setData(config.robotId, config.sessionId, node, de)
end

"""
$(SIGNATURES)
Delete a data element associated with a node.
Return: Nothing if succeed, error if failed.
"""
function deleteData(robotId::String, sessionId::String, node::Union{Int, String, Symbol, NodeResponse, NodeDetailsResponse}, dataId::String)::Nothing
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    # Get the node ID.
    nodeId = typeof(node) == NodeResponse || typeof(node) == NodeDetailsResponse ? node.id : node;
    nodeId = typeof(nodeId) == Symbol ? String(nodeId) : nodeId;

    url = "$(config.apiEndpoint)/$(format(bigDataElementEndpoint, config.userId, robotId, sessionId, nodeId, dataId))"
    response = @mock _sendRestRequest(config, HTTP.delete, url)
    if(response.status != 200)
        error("Error deleting data element '$dataId', received $(response.status) with body '$(String(response.body))'.")
    end

    # Update the cache
    if isdefined(GraffSDK, :__localCache)
        cacheKey = "$(config.userId)|$robotId|$sessionId|$nodeId|$dataId"
        @debug "Deleting cache key '$cacheKey'..."
        deleteElement(cacheKey)
    end

    return nothing
end

"""
$(SIGNATURES)
Delete a data element associated with a node.
Return: Nothing if succeed, error if failed.
"""
function deleteData(node::Union{Int, NodeResponse, NodeDetailsResponse}, dataId::String)::Nothing
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    if config.robotId == "" || config.sessionId == ""
        error("Your config doesn't have a robot or a session specified, please attach your config to a valid robot or session by setting the robotId and sessionId fields. Robot = $(config.robotId), Session = $(config.sessionId)")
    end

    return deleteData(config.robotId, config.sessionId, node, dataId)
end

"""
$(SIGNATURES)
Export a session to a JLD file.
Return: Nothing if succeed, error if failed.
"""
function exportSessionJld(robotId::String, sessionId::String, filename::String)::Nothing
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    if config.robotId == "" || config.sessionId == ""
        error("Your config doesn't have a robot or a session specified, please attach your config to a valid robot or session by setting the robotId and sessionId fields. Robot = $(config.robotId), Session = $(config.sessionId)")
    end

    url = "$(config.apiEndpoint)/$(format(sessionExportJldEndpoint, config.userId, robotId, sessionId))"
    response = @mock _sendRestRequest(config, HTTP.get, url)
    if(response.status != 200)
        error("Error exporting session, received $(response.status) with body '$(String(response.body))'.")
    end
    out =  open(filename,"w")
    write(out,response.body)
    close(out)

    return nothing
end

"""
$(SIGNATURES)
Export a session to a JLD file.
Return: Nothing if succeed, error if failed.
"""
function exportSessionJld(filename::String)::Nothing
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    if config.robotId == "" || config.sessionId == ""
        error("Your config doesn't have a robot or a session specified, please attach your config to a valid robot or session by setting the robotId and sessionId fields. Robot = $(config.robotId), Session = $(config.sessionId)")
    end

    return exportSessionJld(config.robotId, config.sessionId, filename)
end
