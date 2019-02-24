curVersion = "v0"
sessionQueueLengthEndpoint = "api/$curVersion/users/{1}/robots/{2}/sessions/{3}/queue/status"
sessionDeadQueueLengthEndpoint = "api/$curVersion/users/{1}/robots/{2}/sessions/{3}/queue/dead"

"""
$(SIGNATURES)
Get the asynchonous session queue length.
"""
function getSessionBacklog(robotId::String, sessionId::String)::Int
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    url = "$(config.apiEndpoint)/$(format(sessionQueueLengthEndpoint, config.userId, robotId, sessionId))"
    response = @mock _sendRestRequest(config, HTTP.get, url)
    if(response.status != 200)
        error("Error getting session queue backlog, received $(response.status) with body '$(String(response.body))'.")
    end
    return parse(Int64, String(response.body))
end

"""
$(SIGNATURES)
Get the asynchonous session queue length.
"""
function getSessionBacklog()::Int
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    if config.robotId == "" || config.sessionId == ""
        error("Your config doesn't have a robot or a session specified, please attach your config to a valid robot or session by setting the robotId and sessionId fields. Robot = $(config.robotId), Session = $(config.sessionId)")
    end

    return getSessionBacklog(config.robotId, config.sessionId)
end

"""
$(SIGNATURES)
Get the asynchonous session dead message queue length.
"""
function getSessionDeadQueueLength(robotId::String, sessionId::String)::Int
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    url = "$(config.apiEndpoint)/$(format(sessionDeadQueueLengthEndpoint, config.userId, robotId, sessionId))/status"
    response = @mock _sendRestRequest(config, HTTP.get, url)
    if(response.status != 200)
        error("Error getting length of dead message queue, received $(response.status) with body '$(String(response.body))'.")
    end
    return parse(Int64, String(response.body))
end

"""
$(SIGNATURES)
Get the asynchonous session dead message queue length.
"""
function getSessionDeadQueueLength()::Int
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    if config.robotId == "" || config.sessionId == ""
        error("Your config doesn't have a robot or a session specified, please attach your config to a valid robot or session by setting the robotId and sessionId fields. Robot = $(config.robotId), Session = $(config.sessionId)")
    end

    return getSessionDeadQueueLength(config.robotId, config.sessionId)
end

"""
$(SIGNATURES)
Get the messages in the asynchonous session dead message queue.
"""
function getSessionDeadQueueMessages(robotId::String, sessionId::String)::Any
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    url = "$(config.apiEndpoint)/$(format(sessionDeadQueueLengthEndpoint, config.userId, robotId, sessionId))"
    response = @mock _sendRestRequest(config, HTTP.get, url)
    if(response.status != 200)
        error("Error getting all dead queue messages, received $(response.status) with body '$(String(response.body))'.")
    end
    body = JSON2.read(String(response.body))
    return body
end

"""
$(SIGNATURES)
Get the messages in the asynchonous session dead message queue.
"""
function getSessionDeadQueueMessages()::Any
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    if config.robotId == "" || config.sessionId == ""
        error("Your config doesn't have a robot or a session specified, please attach your config to a valid robot or session by setting the robotId and sessionId fields. Robot = $(config.robotId), Session = $(config.sessionId)")
    end

    return getSessionDeadQueueMessages(config.robotId, config.sessionId)
end

"""
$(SIGNATURES)
Get the messages in the asynchonous session dead message queue.
"""
function reprocessDeadQueueMessages(robotId::String, sessionId::String)::Nothing
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    url = "$(config.apiEndpoint)/$(format(sessionDeadQueueLengthEndpoint, config.userId, robotId, sessionId))"
    response = @mock _sendRestRequest(config, HTTP.put, url)
    if(response.status != 200)
        error("Error requesting server reprocess dead queue messages, received $(response.status) with body '$(String(response.body))'.")
    end
    return nothing
end

"""
$(SIGNATURES)
Get the messages in the asynchonous session dead message queue.
"""
function reprocessDeadQueueMessages()::Nothing
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    if config.robotId == "" || config.sessionId == ""
        error("Your config doesn't have a robot or a session specified, please attach your config to a valid robot or session by setting the robotId and sessionId fields. Robot = $(config.robotId), Session = $(config.sessionId)")
    end

    return reprocessDeadQueueMessages(config.robotId, config.sessionId)
end

"""
$(SIGNATURES)
Deletes the messages in the asynchonous session dead message queue.
"""
function deleteDeadQueueMessages(robotId::String, sessionId::String)::Nothing
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    url = "$(config.apiEndpoint)/$(format(sessionDeadQueueLengthEndpoint, config.userId, robotId, sessionId))"
    response = @mock _sendRestRequest(config, HTTP.delete, url)
    if(response.status != 200)
        error("Error manually deleting dead message queue, received $(response.status) with body '$(String(response.body))'.")
    end
    return nothing
end

"""
$(SIGNATURES)
Deletes the messages in the asynchonous session dead message queue.
"""
function deleteDeadQueueMessages()::Nothing
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    if config.robotId == "" || config.sessionId == ""
        error("Your config doesn't have a robot or a session specified, please attach your config to a valid robot or session by setting the robotId and sessionId fields. Robot = $(config.robotId), Session = $(config.sessionId)")
    end

    return deleteDeadQueueMessages(config.robotId, config.sessionId)
end
