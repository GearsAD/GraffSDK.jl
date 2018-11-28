sessionsEndpoint = "api/v0/users/{1}/robots/{2}/sessions"
sessionEndpoint = "api/v0/users/{1}/robots/{2}/sessions/{3}"
nodesEndpoint = "api/v0/users/{1}/robots/{2}/sessions/{3}/nodes"
nodeEndpoint = "api/v0/users/{1}/robots/{2}/sessions/{3}/nodes/{4}"
bigDataEndpoint = "api/v0/users/{1}/robots/{2}/sessions/{3}/nodes/{4}/data"
bigDataElementEndpoint = "api/v0/users/{1}/robots/{2}/sessions/{3}/nodes/{4}/data/{5}"
bigDataRawElementEndpoint = "api/v0/users/{1}/robots/{2}/sessions/{3}/nodes/{4}/data/{5}/raw"
nodeLabelledEndpoint = "api/v0/users/{1}/robots/{2}/sessions/{3}/nodes/labelled/{4}"
odoEndpoint = "api/v0/users/{1}/robots/{2}/sessions/{3}/odometry"
sessionReadyEndpoint = "api/v0/users/{1}/robots/{2}/sessions/{3}/ready/{4}"
variableEndpoint = "api/v0/users/{1}/robots/{2}/sessions/{3}/variables/{4}"
factorsEndpoint = "api/v0/users/{1}/robots/{2}/sessions/{3}/factors"
factorEndpoint = "$factorsEndpoint/{4}"
bearingRangeEndpoint = "api/v0/users/{1}/robots/{2}/sessions/{3}/factors/bearingrange"

"""
$(SIGNATURES)
Gets all sessions for the current robot.
Return: A vector of sessions for the current robot.
"""
function getSessions(robotId::String)::SessionsResponse
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    url = "$(config.apiEndpoint)/$(format(sessionsEndpoint, config.userId, robotId))"
    response = @mock _sendRestRequest(config, HTTP.get, url)
    if(response.status != 200)
        error("Error getting sessions, received $(response.status) with body '$(String(response.body))'.")
    end
    # Some manual effort done here because it's a vector response.
    rawSessions = JSON.parse(String(response.body))
    sessions = SessionsResponse(Vector{SessionResponse}(), rawSessions["links"])
    for session in rawSessions["sessions"]
        session = _unmarshallWithLinks(JSON.json(session), SessionResponse)
        push!(sessions.sessions, session)
    end

    #Sort
    sort!(sessions.sessions, by=(s -> s.id))
    return sessions
end

"""
$(SIGNATURES)
Gets all sessions for the current robot.
Return: A vector of sessions for the current robot.
"""
function getSessions()::SessionsResponse
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
    sessions = getSessions(robotId)
    return count(sess -> lowercase(strip(sess.id)) == lowercase(strip(sessionId)), sessions.sessions) > 0
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
    return _unmarshallWithLinks(String(response.body), SessionDetailsResponse)
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
    response = @mock _sendRestRequest(config, HTTP.post, url, data=JSON.json(session))
    if(response.status != 200)
        error("Error creating session, received $(response.status) with body '$(String(response.body))'.")
    end
    return _unmarshallWithLinks(String(response.body), SessionDetailsResponse)
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
function getNodes(robotId::String, sessionId::String)::NodesResponse
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    url = "$(config.apiEndpoint)/$(format(nodesEndpoint, config.userId, robotId, sessionId))"
    response = @mock _sendRestRequest(config, HTTP.get, url)
    if(response.status != 200)
        error("Error getting sessions, received $(response.status) with body '$(String(response.body))'.")
    end
    # Some manual effort done here because it's a vector response.
    rawNodes = JSON.parse(String(response.body))
    nodes = NodesResponse(Vector{NodeResponse}(), rawNodes["links"])
    for node in rawNodes["nodes"]
        node = _unmarshallWithLinks(JSON.json(node), NodeResponse)
        push!(nodes.nodes, node)
    end

    sort!(nodes.nodes; by=(n -> n.label))
    return nodes
end

"""
$(SIGNATURES)
Gets all nodes for a given session.
Return: A vector of nodes for a given robot.
"""
function getNodes()::NodesResponse
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    if config.robotId == "" || config.sessionId == ""
        error("Your config doesn't have a robot or a session specified, please attach your config to a valid robot or session by setting the robotId and sessionId fields. Robot = $(config.robotId), Session = $(config.sessionId)")
    end

    return getNodes(config.robotId, config.sessionId)
end


"""
$(SIGNATURES)
Gets a node's details by either its ID or name.
Return: A node's details.
"""
function getNode(robotId::String, sessionId::String, nodeIdOrLabel::Union{Int, String})::NodeDetailsResponse
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    url = "$(config.apiEndpoint)/$(format(nodeEndpoint, config.userId, robotId, sessionId, nodeIdOrLabel))"
    if(typeof(nodeIdOrLabel) == String)
        url = "$(config.apiEndpoint)/$(format(nodeLabelledEndpoint, config.userId, robotId, sessionId, nodeIdOrLabel))"
    end
    response = @mock _sendRestRequest(config, HTTP.get, url)
    if(response.status != 200)
        error("Error getting node, received $(response.status) with body '$(String(response.body))'.")
    end
    # Some manual effort done
    rawNode = JSON.parse(String(response.body))
    node = NodeDetailsResponse(rawNode["id"], rawNode["label"], rawNode["sessionIndex"], rawNode["properties"], rawNode["packed"], rawNode["labels"], rawNode["links"])
    return node
end

"""
$(SIGNATURES)
Gets a node's details by either its ID or name.
Return: A node's details.
"""
function getNode(nodeIdOrLabel::Union{Int, String})::NodeDetailsResponse
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    if config.robotId == "" || config.sessionId == ""
        error("Your config doesn't have a robot or a session specified, please attach your config to a valid robot or session by setting the robotId and sessionId fields. Robot = $(config.robotId), Session = $(config.sessionId)")
    end

    return getNode(config.robotId, config.sessionId, nodeIdOrLabel)
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
Create a variable in Synchrony.
Return: Returns the ID+label of the created variable.
"""
function addVariable(robotId::String, sessionId::String, variableRequest::VariableRequest)::NodeResponse
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    url = "$(config.apiEndpoint)/$(format(variableEndpoint, config.userId, robotId, sessionId, variableRequest.label))"
    response = @mock _sendRestRequest(config, HTTP.post, url, data=JSON.json(variableRequest))
    if(response.status != 200)
        error("Error creating variable, received $(response.status) with body '$(String(response.body))'.")
    end
    return _unmarshallWithLinks(String(response.body), NodeResponse)
end

"""
$(SIGNATURES)
Create a variable in Synchrony.
Return: Returns the ID+label of the created variable.
"""
function addVariable(variableRequest::VariableRequest)::NodeResponse
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
function addVariable(label::String, varType::String, additionalLabels::Vector{String}=Vector{String}())::NodeResponse
    return addVariable(VariableRequest(label, varType, additionalLabels))
end

"""
$(SIGNATURES)
Create a factor in Synchrony.
Return: Returns the ID+label of the created factor.
"""
function addFactor(robotId::String, sessionId::String, factorRequest::FactorRequest)::NodeResponse
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    url = "$(config.apiEndpoint)/$(format(factorsEndpoint, config.userId, robotId, sessionId))"
    response = @mock _sendRestRequest(config, HTTP.post, url, data=JSON.json(factorRequest))
    if(response.status != 200)
        error("Error creating factor, received $(response.status) with body '$(String(response.body))'.")
    end
    return _unmarshallWithLinks(String(response.body), NodeResponse)
end

"""
$(SIGNATURES)
Create a factor in Synchrony.
Return: Returns the ID+label of the created factor.
"""
function addFactor(factorRequest::FactorRequest)::NodeResponse
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
Create a variable in Synchrony and associate it with the given robot+user.
Return: Returns ID+label of the created factor.
"""
function addBearingRangeFactor(robotId::String, sessionId::String, bearingRangeRequest::BearingRangeRequest)::NodeResponse
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    url = "$(config.apiEndpoint)/$(format(bearingRangeEndpoint, config.userId, robotId, sessionId))"
    response = @mock _sendRestRequest(config, HTTP.post, url, data=JSON.json(bearingRangeRequest))
    if(response.status != 200)
        error("Error creating bearing range factor, received $(response.status) with body '$(String(response.body))'.")
    end
    return _unmarshallWithLinks(String(response.body), NodeResponse)
end

"""
$(SIGNATURES)
Create a variable in Synchrony and associate it with the given robot+user.
Return: Returns ID+label of the created factor.
"""
function addBearingRangeFactor(bearingRangeRequest::BearingRangeRequest)::NodeResponse
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
function addOdometryMeasurement(robotId::String, sessionId::String, addOdoRequest::AddOdometryRequest)::AddOdometryResponse
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    url = "$(config.apiEndpoint)/$(format(odoEndpoint, config.userId, robotId, sessionId))"
    response = @mock _sendRestRequest(config, HTTP.post, url, data=JSON.json(addOdoRequest))
    if(response.status != 200)
        error("Error creating odometry, received $(response.status) with body '$(String(response.body))'.")
    end
    return Unmarshal.unmarshal(AddOdometryResponse, JSON.parse(String(response.body)))
end

"""
$(SIGNATURES)
Create a session in Synchrony and associate it with the given robot+user.
Return: Returns the added odometry information.
"""
function addOdometryMeasurement(addOdoRequest::AddOdometryRequest)::AddOdometryResponse
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
function addOdometryMeasurement(odoDelta::Vector{Float64}, pOdo::Matrix{Float64})::AddOdometryResponse
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
        bigDataRaw = JSON.parse(String(response.body))
        datas = Vector{BigDataEntryResponse}()
        for bd in bigDataRaw
            push!(datas, _unmarshallWithLinks(JSON.json(bd), BigDataEntryResponse))
        end

        sort(datas; by=(d -> n.id))

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
function getDataElement(robotId::String, sessionId::String, node::Union{Int, NodeResponse, NodeDetailsResponse}, bigDataKey::String)::BigDataElementResponse
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    # Get the node ID.
    nodeId = typeof(node) != Int ? node.id : node;

    url = "$(config.apiEndpoint)/$(format(bigDataElementEndpoint, config.userId, robotId, sessionId, nodeId, bigDataKey))"
    response = @mock _sendRestRequest(config, HTTP.get, url)
    if(response.status != 200)
        error("Error getting node data entries, received $(response.status) with body '$(String(response.body))'.")
    end
    return _unmarshallWithLinks(String(response.body), BigDataElementResponse)
end

"""
$(SIGNATURES)
Get data elment associated with a node.
Return: Full data element associated with the specified node.
"""
function getDataElement( node::Union{Int, NodeResponse, NodeDetailsResponse}, bigDataKey::String)::BigDataElementResponse
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    if config.robotId == "" || config.sessionId == ""
        error("Your config doesn't have a robot or a session specified, please attach your config to a valid robot or session by setting the robotId and sessionId fields. Robot = $(config.robotId), Session = $(config.sessionId)")
    end

    return getDataElement(config.robotId, config.sessionId, node, bigDataKey)
end

"""
$(SIGNATURES)
Get data elment associated with a node.
Return: Full data element associated with the specified node.
"""
function getRawDataElement(robotId::String, sessionId::String, node::Union{Int, NodeResponse, NodeDetailsResponse}, bigDataKey::String)::String
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    # Get the node ID.
    nodeId = typeof(node) != Int ? node.id : node;

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
function getRawDataElement(node::Union{Int, NodeResponse, NodeDetailsResponse}, bigDataKey::String)::String
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    if config.robotId == "" || config.sessionId == ""
        error("Your config doesn't have a robot or a session specified, please attach your config to a valid robot or session by setting the robotId and sessionId fields. Robot = $(config.robotId), Session = $(config.sessionId)")
    end

    return getRawDataElement(config.robotId, config.sessionId, node, bigDataKey)
end

"""
$(SIGNATURES)
Add a data element associated with a node.
Return: Nothing if succeed, error if failed.
"""
function addDataElement(robotId::String, sessionId::String, node::Union{Int, NodeResponse, NodeDetailsResponse}, bigDataElement::BigDataElementRequest)::Nothing
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    # Get the node ID.
    nodeId = typeof(node) != Int ? node.id : node;

    url = "$(config.apiEndpoint)/$(format(bigDataElementEndpoint, config.userId, robotId, sessionId, nodeId, bigDataElement.id))"
    response = @mock _sendRestRequest(config, HTTP.post, url, data=JSON.json(bigDataElement))
    if(response.status != 200)
        error("Error adding data element, received $(response.status) with body '$(String(response.body))'.")
    end
    return nothing
end

"""
$(SIGNATURES)
Add a data element associated with a node.
Return: Nothing if succeed, error if failed.
"""
function addDataElement(node::Union{Int, NodeResponse, NodeDetailsResponse}, bigDataElement::BigDataElementRequest)::Nothing
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    if config.robotId == "" || config.sessionId == ""
        error("Your config doesn't have a robot or a session specified, please attach your config to a valid robot or session by setting the robotId and sessionId fields. Robot = $(config.robotId), Session = $(config.sessionId)")
    end

    return addDataElement(config.robotId, config.sessionId, node, bigDataElement)
end

"""
$(SIGNATURES)
Update a data element associated with a node.
Return: Nothing if succeed, error if failed.
"""
function updateDataElement(robotId::String, sessionId::String, node::Union{Int, NodeResponse, NodeDetailsResponse}, bigDataElement::Union{BigDataElementRequest, BigDataElementResponse})::Nothing
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    # Get the node ID.
    nodeId = typeof(node) != Int ? node.id : node;

    url = "$(config.apiEndpoint)/$(format(bigDataElementEndpoint, config.userId, robotId, sessionId, nodeId, bigDataElement.id))"
    response = @mock _sendRestRequest(config, HTTP.put, url, data=JSON.json(bigDataElement))
    if(response.status != 200)
        error("Error updating data element '$(bigDataElement.id)', received $(response.status) with body '$(String(response.body))'.")
    end
    return nothing
end

"""
$(SIGNATURES)
Update a data element associated with a node.
Return: Nothing if succeed, error if failed.
"""
function updateDataElement(node::Union{Int, NodeResponse, NodeDetailsResponse}, bigDataElement::Union{BigDataElementRequest, BigDataElementResponse})::Nothing
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    if config.robotId == "" || config.sessionId == ""
        error("Your config doesn't have a robot or a session specified, please attach your config to a valid robot or session by setting the robotId and sessionId fields. Robot = $(config.robotId), Session = $(config.sessionId)")
    end

    return updateDataElement(config.robotId, config.sessionId, node, bigDataElement)
end

"""
$(SIGNATURES)
Add or update a data element associated with a node. Will check if the key exists, if so it updates, otherwise it adds.
Return: Nothing if succeed, error if failed.
"""
function addOrUpdateDataElement(robotId::String, sessionId::String, node::Union{Int, NodeResponse, NodeDetailsResponse}, dataElement::Union{BigDataElementRequest, BigDataElementResponse})::Nothing
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    # Get the node ID.
    nodeId = typeof(node) != Int ? node.id : node;

    dataEntries = getDataEntries(robotId, sessionId, nodeId)
    if count(entry -> entry.id == dataElement.id, dataEntries) == 0
        println("Existence test for ID '$(dataElement.id)' failed - Adding it!")
        return addDataElement(robotId, sessionId, nodeId, dataElement)
    else
        println("Existence test for ID '$(dataElement.id)' passed - Updating it!")
        updateDataElement(robotId, sessionId, nodeId, dataElement)
    end
    return nothing
end

function addOrUpdateDataElement(node::Union{Int, NodeResponse, NodeDetailsResponse}, dataElement::Union{BigDataElementRequest, BigDataElementResponse})::Nothing
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    return addOrUpdateDataElement(config.robotId, config.sessionId, node, dataElement)
end

"""
$(SIGNATURES)
Delete a data element associated with a node.
Return: Nothing if succeed, error if failed.
"""
function deleteDataElement(robotId::String, sessionId::String, node::Union{Int, NodeResponse, NodeDetailsResponse}, dataId::String)::Nothing
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    # Get the node ID.
    nodeId = typeof(node) != Int ? node.id : node;

    url = "$(config.apiEndpoint)/$(format(bigDataElementEndpoint, config.userId, robotId, sessionId, nodeId, dataId))"
    response = @mock _sendRestRequest(config, HTTP.delete, url)
    if(response.status != 200)
        error("Error deleting data element '$dataId', received $(response.status) with body '$(String(response.body))'.")
    end
    return nothing
end

"""
$(SIGNATURES)
Delete a data element associated with a node.
Return: Nothing if succeed, error if failed.
"""
function deleteDataElement(node::Union{Int, NodeResponse, NodeDetailsResponse}, dataId::String)::Nothing
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    if config.robotId == "" || config.sessionId == ""
        error("Your config doesn't have a robot or a session specified, please attach your config to a valid robot or session by setting the robotId and sessionId fields. Robot = $(config.robotId), Session = $(config.sessionId)")
    end

    return deleteDataElement(config.robotId, config.sessionId, node, dataId)
end
