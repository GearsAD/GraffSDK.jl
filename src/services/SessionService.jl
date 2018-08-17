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
function getSessions(config::SynchronyConfig, robotId::String)::SessionsResponse
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
    return sessions
end

"""
$(SIGNATURES)
Gets all sessions for the current robot.
Return: A vector of sessions for the current robot.
"""
function getSessions(config::SynchronyConfig)::SessionsResponse
    return getSessions(config, config.robotId)
end

"""
$(SIGNATURES)
Return: Returns true if the session exists already.
"""
function isSessionExisting(config::SynchronyConfig, robotId::String, sessionId::String)::Bool
    sessions = getSessions(config, robotId)
    return count(sess -> lowercase(strip(sess.id)) == lowercase(strip(sessionId)), sessions.sessions) > 0
end

"""
$(SIGNATURES)
Return: Returns true if the session exists already.
"""
function isSessionExisting(config::SynchronyConfig)::Bool
    return isSessionExisting(config, config.robotId, config.sessionId)
end

"""
$(SIGNATURES)
Get a specific session given a user ID, robot ID, and session ID.
Return: The session details for the provided user ID, robot ID, and session ID.
"""
function getSession(config::SynchronyConfig, robotId::String, sessionId::String)::SessionDetailsResponse
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
function getSession(config::SynchronyConfig)::SessionDetailsResponse
    return getSession(config, config.robotId, config.sessionId)
end

"""
$(SIGNATURES)
Delete a specific session given a user ID, robot ID, and session ID.
Return: Nothing if success, error if failed.
"""
function deleteSession(config::SynchronyConfig, robotId::String, sessionId::String)::Void
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
function deleteSession(config::SynchronyConfig, robotId::String, sessionId::String)::Void
    return deleteSession(config, robotId, sessionId)
end


"""
$(SIGNATURES)
Create a session in Synchrony and associate it with the given robot+user.
Return: Returns the created session.
"""
function addSession(config::SynchronyConfig, robotId::String, session::SessionDetailsRequest)::SessionDetailsResponse
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
function addSession(config::SynchronyConfig, session::SessionDetailsRequest)::SessionDetailsResponse
    return addSession(config, config.robotId, session)
end

"""
$(SIGNATURES)
Gets all nodes for a given session.
Return: A vector of nodes for a given robot.
"""
function getNodes(config::SynchronyConfig, robotId::String, sessionId::String)::NodesResponse
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
    return nodes
end

"""
$(SIGNATURES)
Gets all nodes for a given session.
Return: A vector of nodes for a given robot.
"""
function getNodes(config::SynchronyConfig)::NodesResponse
    return getNodes(config, config.robotId, config.sessionId)
end


"""
$(SIGNATURES)
Gets a node's details by either its ID or name.
Return: A node's details.
"""
function getNode(config::SynchronyConfig, robotId::String, sessionId::String, nodeIdOrLabel::Union{Int, String})::NodeDetailsResponse
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
function getNode(config::SynchronyConfig, nodeIdOrLabel::Union{Int, String})::NodeDetailsResponse
    return getNode(config, config.robotId, config.sessionId, nodeIdOrLabel)
end

"""
$(SIGNATURES)
Set the ready status for a session.
"""
function putReady(config::SynchronyConfig, robotId::String, sessionId::String, isReady::Bool)::Void
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
function putReady(config::SynchronyConfig, isReady::Bool)::Void
    return putReady(config, config.robotId, config.sessionId, isReady)
end

"""
$(SIGNATURES)
Create a variable in Synchrony.
Return: Returns the ID+label of the created variable.
"""
function addVariable(config::SynchronyConfig, robotId::String, sessionId::String, variableRequest::VariableRequest)::NodeResponse
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
function addVariable(config::SynchronyConfig, variableRequest::VariableRequest)::NodeResponse
    return addVariable(config, config.robotId, config.sessionId,variableRequest)
end

"""
$(SIGNATURES)
Create a factor in Synchrony.
Return: Returns the ID+label of the created factor.
"""
function addFactor(config::SynchronyConfig, robotId::String, sessionId::String, factorRequest::FactorRequest)::NodeResponse
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
function addFactor(config::SynchronyConfig, factorRequest::FactorRequest)::NodeResponse
    return addFactor(config, config.robotId, config.sessionId, FactorRequest)
end

"""
$(SIGNATURES)
Create a variable in Synchrony and associate it with the given robot+user.
Return: Returns ID+label of the created factor.
"""
function addBearingRangeFactor(config::SynchronyConfig, robotId::String, sessionId::String, bearingRangeRequest::BearingRangeRequest)::NodeResponse
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
function addBearingRangeFactor(config::SynchronyConfig, bearingRangeRequest::BearingRangeRequest)::NodeResponse
    return addBearingRangeFactor(config, config.robotId, config.sessionId, bearingRangeRequest)
end

"""
$(SIGNATURES)
Create a session in Synchrony and associate it with the given robot+user.
Return: Returns the added odometry information.
"""
function addOdometryMeasurement(config::SynchronyConfig, robotId::String, sessionId::String, addOdoRequest::AddOdometryRequest)::AddOdometryResponse
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
function addOdometryMeasurement(config::SynchronyConfig, addOdoRequest::AddOdometryRequest)::AddOdometryResponse
    url = "$(config.apiEndpoint)/$(format(odoEndpoint, config.userId, robotId, sessionId))"
    response = @mock _sendRestRequest(config, HTTP.post, url, data=JSON.json(addOdoRequest))
    if(response.status != 200)
        error("Error creating odometry, received $(response.status) with body '$(String(response.body))'.")
    end
    return Unmarshal.unmarshal(AddOdometryResponse, JSON.parse(String(response.body)))
end

"""
$(SIGNATURES)
Get data entries associated with a node.
Return: Summary of all data associated with a node.
"""
function getDataEntries(config::SynchronyConfig, robotId::String, sessionId::String, nodeId::Int)::Vector{BigDataEntryResponse}
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
        return datas
    end
end

"""
$(SIGNATURES)
Get data elment associated with a node.
Return: Full data element associated with the specified node.
"""
function getDataElement(config::SynchronyConfig, robotId::String, sessionId::String, nodeId::Int, bigDataKey::String)::BigDataElementResponse
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
function getRawDataElement(config::SynchronyConfig, robotId::String, sessionId::String, nodeId::Int, bigDataKey::String)::String
    url = "$(config.apiEndpoint)/$(format(bigDataRawElementEndpoint, config.userId, robotId, sessionId, nodeId, bigDataKey))"
    response = @mock _sendRestRequest(config, HTTP.get, url)
    if(response.status != 200)
        error("Error getting node data entries, received $(response.status) with body '$(String(response.body))'.")
    end
    return String(response.body)
end

"""
$(SIGNATURES)
Add a data element associated with a node.
Return: Nothing if succeed, error if failed.
"""
function addDataElement(config::SynchronyConfig, robotId::String, sessionId::String, nodeId::Int, bigDataElement::BigDataElementRequest)::Void
    url = "$(config.apiEndpoint)/$(format(bigDataElementEndpoint, config.userId, robotId, sessionId, nodeId, bigDataElement.id))"
    response = @mock _sendRestRequest(config, HTTP.post, url, data=JSON.json(bigDataElement))
    if(response.status != 200)
        error("Error adding data element, received $(response.status) with body '$(String(response.body))'.")
    end
    return nothing
end

"""
$(SIGNATURES)
Update a data element associated with a node.
Return: Nothing if succeed, error if failed.
"""
function updateDataElement(config::SynchronyConfig, robotId::String, sessionId::String, nodeId::Int, bigDataElement::Union{BigDataElementRequest, BigDataElementResponse})::Void
    url = "$(config.apiEndpoint)/$(format(bigDataElementEndpoint, config.userId, robotId, sessionId, nodeId, bigDataElement.id))"
    response = @mock _sendRestRequest(config, HTTP.put, url, data=JSON.json(bigDataElement))
    if(response.status != 200)
        error("Error updating data element '$(bigDataElement.id)', received $(response.status) with body '$(String(response.body))'.")
    end
    return nothing
end

"""
$(SIGNATURES)
Add or update a data element associated with a node. Will check if the key exists, if so it updates, otherwise it adds.
Return: Nothing if succeed, error if failed.
"""
function addOrUpdateDataElement(config::SynchronyConfig, robotId::String, sessionId::String, node::Union{NodeResponse, NodeDetailsResponse}, dataElement::Union{BigDataElementRequest, BigDataElementResponse})::Void
    return addOrUpdateDataElement(config, robotId, sessionId, node.id, dataElement::Union{BigDataElementRequest, BigDataElementResponse})
end

"""
$(SIGNATURES)
Add or update a data element associated with a node. Will check if the key exists, if so it updates, otherwise it adds.
Return: Nothing if succeed, error if failed.
"""
function addOrUpdateDataElement(config::SynchronyConfig, robotId::String, sessionId::String, nodeId::Int, dataElement::Union{BigDataElementRequest, BigDataElementResponse})::Void
    dataEntries = getDataEntries(config, robotId, sessionId, nodeId)
    if count(entry -> entry.id == dataElement.id, dataEntries) == 0
        println("Existence test for ID '$(dataElement.id)' failed - Adding it!")
        return addDataElement(config, robotId, sessionId, nodeId, dataElement)
    else
        println("Existence test for ID '$(dataElement.id)' passed - Updating it!")
        updateDataElement(config, robotId, sessionId, nodeId, dataElement)
    end
    return nothing
end

"""
$(SIGNATURES)
Delete a data element associated with a node.
Return: Nothing if succeed, error if failed.
"""
function deleteDataElement(config::SynchronyConfig, robotId::String, sessionId::String, nodeId::Int, dataId::String)::Void
    url = "$(config.apiEndpoint)/$(format(bigDataElementEndpoint, config.userId, robotId, sessionId, nodeId, dataId))"
    response = @mock _sendRestRequest(config, HTTP.delete, url)
    if(response.status != 200)
        error("Error deleting data element '$dataId', received $(response.status) with body '$(String(response.body))'.")
    end
    return nothing
end
