include("../entities/Auth.jl")
include("../entities/Session.jl")

sessionsEndpoint = "api/v0/users/{1}/robots/{2}/sessions"
sessionEndpoint = "api/v0/users/{1}/robots/{2}/sessions/{3}"
nodesEndpoint = "api/v0/users/{1}/robots/{2}/sessions/{3}/nodes"
nodeEndpoint = "api/v0/users/{1}/robots/{2}/sessions/{3}/nodes/{4}"
odoEndpoint = "api/v0/users/{1}/robots/{2}/sessions/{3}/odometry"

"""
    getSessions(config::SynchronyConfig, auth::AuthResponse, userId::String, robotId::String)::SessionsResponse
Gets all sessions for a given robot.
Return: A vector of sessions for a given robot.
"""
function getSessions(config::SynchronyConfig, auth::AuthResponse, userId::String, robotId::String)::SessionsResponse
    url = "$(config.apiEndpoint):$(config.apiPort)/$(format(sessionsEndpoint, userId, robotId))"
    response = get(url; headers = Dict("token" => auth.token))
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
    getSession(config::SynchronyConfig, auth::AuthResponse, userId::String, robotId::String, sessionId::String)::SessionDetailsResponse
Get a specific session given a user ID, robot ID, and session ID.
Return: The session details for the provided user ID, robot ID, and session ID.
"""
function getSession(config::SynchronyConfig, auth::AuthResponse, userId::String, robotId::String, sessionId::String)::SessionDetailsResponse
    url = "$(config.apiEndpoint):$(config.apiPort)/$(format(sessionEndpoint, userId, robotId, sessionId))"
    response = get(url; headers = Dict("token" => auth.token))
    if(statuscode(response) != 200)
        error("Error getting session, received $(statuscode(response)) with body '$(readstring(response))'.")
    else
        return _unmarshallWithLinks(readstring(response), SessionDetailsResponse)
    end
end

"""
    createSession(config::SynchronyConfig, auth::AuthResponse, userId::String, robotId::String, session::SessionDetailsRequest)::SessionDetailsResponse
Create a session in Synchrony and associate it with the given robot+user.
Return: Returns the created session.
"""
function createSession(config::SynchronyConfig, auth::AuthResponse, userId::String, robotId::String, session::SessionDetailsRequest)::SessionDetailsResponse
    url = "$(config.apiEndpoint):$(config.apiPort)/$(format(sessionEndpoint, userId, robotId, session.id))"
    response = post(url; headers = Dict("token" => auth.token), data=JSON.json(session))
    if(statuscode(response) != 200)
        error("Error creating session, received $(statuscode(response)) with body '$(readstring(response))'.")
    else
        return _unmarshallWithLinks(readstring(response), SessionDetailsResponse)
    end
end

"""
    getNodes(config::SynchronyConfig, auth::AuthResponse, userId::String, robotId::String, sessionId::String)::NodesResponse
Gets all nodes for a given session.
Return: A vector of nodes for a given robot.
"""
function getNodes(config::SynchronyConfig, auth::AuthResponse, userId::String, robotId::String, sessionId::String)::NodesResponse
    url = "$(config.apiEndpoint):$(config.apiPort)/$(format(nodesEndpoint, userId, robotId, sessionId))"
    response = get(url; headers = Dict("token" => auth.token))
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
    getNode(config::SynchronyConfig, auth::AuthResponse, userId::String, robotId::String, sessionId::String, nodeId::Int)::NodeDetailsResponse
Gets a node's details.
Return: A node's details.
"""
function getNode(config::SynchronyConfig, auth::AuthResponse, userId::String, robotId::String, sessionId::String, nodeId::Int)::NodeDetailsResponse
    url = "$(config.apiEndpoint):$(config.apiPort)/$(format(nodeEndpoint, userId, robotId, sessionId, nodeId))"
    response = get(url; headers = Dict("token" => auth.token))
    if(statuscode(response) != 200)
        error("Error getting sessions, received $(statuscode(response)) with body '$(readstring(response))'.")
    else
        # Some manual effort done
        rawNode = JSON.parse(readstring(response))
        node = NodeDetailsResponse(rawNode["id"], rawNode["name"], rawNode["properties"], rawNode["packed"], rawNode["labels"], rawNode["bigData"], rawNode["links"])
        return node
    end
end

"""
    addOdometryMeasurement(config::SynchronyConfig, auth::AuthResponse, userId::String, robotId::String, session::SessionDetailsRequest)::SessionDetailsResponse
Create a session in Synchrony and associate it with the given robot+user.
Return: Returns the created session.
"""
function addOdometryMeasurement(config::SynchronyConfig, auth::AuthResponse, userId::String, robotId::String, sessionId::String, addOdoRequest::AddOdometryRequest)::AddOdometryResponse
    url = "$(config.apiEndpoint):$(config.apiPort)/$(format(odoEndpoint, userId, robotId, sessionId))"
    response = post(url; headers = Dict("token" => auth.token), data=JSON.json(addOdoRequest))
    if(statuscode(response) != 200)
        error("Error creating odometry, received $(statuscode(response)) with body '$(readstring(response))'.")
    else
        return AddOdometryResponse() #_unmarshallWithLinks(readstring(response), AddOdometryResponse)
    end
end
