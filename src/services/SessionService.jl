include("../entities/Session.jl")

sessionsEndpoint = "api/v0/users/{1}/robots/{2}/sessions"
sessionEndpoint = "api/v0/users/{1}/robots/{2}/sessions/{3}"
nodesEndpoint = "api/v0/users/{1}/robots/{2}/sessions/{3}/nodes"
nodeEndpoint = "api/v0/users/{1}/robots/{2}/sessions/{3}/nodes/{4}"
nodeLabelledEndpoint = "api/v0/users/{1}/robots/{2}/sessions/{3}/nodes/labelled/{4}"
odoEndpoint = "api/v0/users/{1}/robots/{2}/sessions/{3}/odometry"
sessionReadyEndpoint = "api/v0/users/{1}/robots/{2}/sessions/{3}/ready/{4}"
variableEndpoint = "api/v0/users/{1}/robots/{2}/sessions/{3}/variables/{4}"
bearingRangeEndpoint = "api/v0/users/{1}/robots/{2}/sessions/{3}/factors/bearingrange"

"""
    getSessions(config::SynchronyConfig, robotId::String)::SessionsResponse
Gets all sessions for the current robot.
Return: A vector of sessions for the current robot.
"""
function getSessions(config::SynchronyConfig, robotId::String)::SessionsResponse
    url = "$(config.apiEndpoint):$(config.apiPort)/$(format(sessionsEndpoint, config.userId, robotId))"
    response = get(url; headers = Dict())
    if(statuscode(response) != 200)
        error("Error getting sessions, received $(statuscode(response)) with body '$(readstring(response))'.")
    else
        # Some manual effort done here because it's a vector response.
        rawSessions = JSON.parse(readstring(response))
        sessions = SessionsResponse(Vector{SessionResponse}(), rawSessions["links"])
        for session in rawSessions["sessions"]
            session = _unmarshallWithLinks(JSON.json(session), SessionResponse)
            push!(sessions.sessions, session)
        end
        return sessions
    end
end

"""
    isSessionExisting(config::SynchronyConfig, robotId::String, sessionId::String)::Bool
Return: Returns true if the session exists already.
"""
function isSessionExisting(config::SynchronyConfig, robotId::String, sessionId::String)::Bool
    sessions = getSessions(config, robotId)
    return sessionId in map(sess -> sess.id, sessions.sessions)
end

"""
    getSession(config::SynchronyConfig, robotId::String, sessionId::String)::SessionDetailsResponse
Get a specific session given a user ID, robot ID, and session ID.
Return: The session details for the provided user ID, robot ID, and session ID.
"""
function getSession(config::SynchronyConfig, robotId::String, sessionId::String)::SessionDetailsResponse
    url = "$(config.apiEndpoint):$(config.apiPort)/$(format(sessionEndpoint, config.userId, robotId, sessionId))"
    response = get(url; headers = Dict())
    if(statuscode(response) != 200)
        error("Error getting session, received $(statuscode(response)) with body '$(readstring(response))'.")
    else
        return _unmarshallWithLinks(readstring(response), SessionDetailsResponse)
    end
end

"""
    addSession(config::SynchronyConfig, robotId::String, session::SessionDetailsRequest)::SessionDetailsResponse
Create a session in Synchrony and associate it with the given robot+user.
Return: Returns the created session.
"""
function addSession(config::SynchronyConfig, robotId::String, session::SessionDetailsRequest)::SessionDetailsResponse
    url = "$(config.apiEndpoint):$(config.apiPort)/$(format(sessionEndpoint, config.userId, robotId, session.id))"
    response = post(url; headers = Dict(), data=JSON.json(session))
    if(statuscode(response) != 200)
        error("Error adding session, received $(statuscode(response)) with body '$(readstring(response))'.")
    else
        return _unmarshallWithLinks(readstring(response), SessionDetailsResponse)
    end
end

"""
    getNodes(config::SynchronyConfig, robotId::String, sessionId::String)::NodesResponse
Gets all nodes for a given session.
Return: A vector of nodes for a given robot.
"""
function getNodes(config::SynchronyConfig, robotId::String, sessionId::String)::NodesResponse
    url = "$(config.apiEndpoint):$(config.apiPort)/$(format(nodesEndpoint, config.userId, robotId, sessionId))"
    response = get(url; headers = Dict())
    if(statuscode(response) != 200)
        error("Error getting sessions, received $(statuscode(response)) with body '$(readstring(response))'.")
    else
        # Some manual effort done here because it's a vector response.
        rawNodes = JSON.parse(readstring(response))
        nodes = NodesResponse(Vector{NodeResponse}(), rawNodes["links"])
        for node in rawNodes["nodes"]
            node = _unmarshallWithLinks(JSON.json(node), NodeResponse)
            push!(nodes.nodes, node)
        end
        return nodes
    end
end

"""
    getNode(config::SynchronyConfig, robotId::String, sessionId::String, nodeIdOrLabel::Union{Int, String})::NodeDetailsResponse
Gets a node's details by either its ID or name.
Return: A node's details.
"""
function getNode(config::SynchronyConfig, robotId::String, sessionId::String, nodeIdOrLabel::Union{Int, String})::NodeDetailsResponse
    url = "$(config.apiEndpoint):$(config.apiPort)/$(format(nodeEndpoint, config.userId, robotId, sessionId, nodeIdOrLabel))"
    if(typeof(nodeIdOrLabel) == String)
        url = "$(config.apiEndpoint):$(config.apiPort)/$(format(nodeLabelledEndpoint, config.userId, robotId, sessionId, nodeIdOrLabel))"
    end
    response = get(url; headers = Dict())
    if(statuscode(response) != 200)
        error("Error getting node, received $(statuscode(response)) with body '$(readstring(response))'.")
    else
        # Some manual effort done
        rawNode = JSON.parse(readstring(response))
        node = NodeDetailsResponse(rawNode["id"], rawNode["label"], rawNode["sessionIndex"], rawNode["properties"], rawNode["packed"], rawNode["labels"], rawNode["links"])
        return node
    end
end

"""
    putReady(config::SynchronyConfig, robotId::String, sessionId::String, isReady::Bool)::Void
Set the ready status for a session.
"""
function putReady(config::SynchronyConfig, robotId::String, sessionId::String, isReady::Bool)::Void
    url = "$(config.apiEndpoint):$(config.apiPort)/$(format(sessionReadyEndpoint, config.userId, robotId, sessionId, isReady))"
    response = Requests.put(url; headers = Dict(), data="")
    if(statuscode(response) != 200)
        error("Error updating the ready status of the session, received $(statuscode(response)) with body '$(readstring(response))'.")
    else
        return nothing
    end
end

"""
    addVariable(config::SynchronyConfig, robotId::String, sessionId::String, variableRequest::VariableRequest)::VariableResponse
Create a variable in Synchrony and associate it with the given robot+user.
Return: Returns the created variable.
"""
function addVariable(config::SynchronyConfig, robotId::String, sessionId::String, variableRequest::VariableRequest)::VariableResponse
    url = "$(config.apiEndpoint):$(config.apiPort)/$(format(variableEndpoint, config.userId, robotId, sessionId, variableRequest.label))"
    response = post(url; headers = Dict(), data=JSON.json(variableRequest))
    if(statuscode(response) != 200)
        error("Error creating odometry, received $(statuscode(response)) with body '$(readstring(response))'.")
    else
        return VariableResponse() #_unmarshallWithLinks(readstring(response), AddOdometryResponse)
    end
end

"""
    addVariable(config::SynchronyConfig, robotId::String, sessionId::String, variableRequest::VariableRequest)::VariableResponse
Create a variable in Synchrony and associate it with the given robot+user.
Return: Returns the created variable.
"""
function addBearingRangeFactor(config::SynchronyConfig, robotId::String, sessionId::String, bearingRangeRequest::BearingRangeRequest)::BearingRangeResponse
    url = "$(config.apiEndpoint):$(config.apiPort)/$(format(bearingRangeEndpoint, config.userId, robotId, sessionId))"
    response = post(url; headers = Dict(), data=JSON.json(bearingRangeRequest))
    if(statuscode(response) != 200)
        error("Error creating bearing range factor, received $(statuscode(response)) with body '$(readstring(response))'.")
    else
        return BearingRangeResponse() #_unmarshallWithLinks(readstring(response), AddOdometryResponse)
    end
end

"""
    addOdometryMeasurement(config::SynchronyConfig, robotId::String, session::SessionDetailsRequest)::SessionDetailsResponse
Create a session in Synchrony and associate it with the given robot+user.
Return: Returns the added odometry information.
"""
function addOdometryMeasurement(config::SynchronyConfig, robotId::String, sessionId::String, addOdoRequest::AddOdometryRequest)::AddOdometryResponse
    url = "$(config.apiEndpoint):$(config.apiPort)/$(format(odoEndpoint, config.userId, robotId, sessionId))"
    response = post(url; headers = Dict(), data=JSON.json(addOdoRequest))
    if(statuscode(response) != 200)
        error("Error creating odometry, received $(statuscode(response)) with body '$(readstring(response))'.")
    else
        return Unmarshal.unmarshal(AddOdometryResponse, JSON.parse(readstring(response)))
    end
end
