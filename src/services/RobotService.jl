curVersion = "v0"
robotsEndpoint = "api/$(curVersion)/users/{1}/robots"
robotEndpoint = "api/$(curVersion)/users/{1}/robots/{2}"

"""
$(SIGNATURES)
Gets all robots managed by the specified user.
Return: A vector of robots for a given user.
"""
function getRobots()::Vector{RobotResponse}
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end

    url = "$(config.apiEndpoint)/$(format(robotsEndpoint, config.userId))"
    response = @mock _sendRestRequest(config, HTTP.get, url)
    if(response.status != 200)
        error("Error getting robots, received $(response.status) with body '$(String(response.body))'.")
    end
    # Some manual effort done here because it's a vector response.
    robots = JSON2.read(String(response.body), Vector{RobotResponse})
    return robots
end

"""
$(SIGNATURES)
Return: Returns true if the robot exists already.
"""
function isRobotExisting(robotId::String)::Bool
    url = "$(config.apiEndpoint)/$(format(robotEndpoint, config.userId, robotId))/exists"
    response = @mock _sendRestRequest(config, HTTP.get, url)
    body = String(response.body)
    if(response.status != 200)
        error("Error getting robot existence, received $(response.status) with body '$body'.")
    end
    return lowercase(body) == "true"
end

"""
$(SIGNATURES)
Return: Returns true if the robot in the config exists already.
"""
function isRobotExisting()::Bool
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end

    if config.robotId == ""
        error("Your config doesn't have a robot specified, please attach your config to a valid robot by setting the robotId field. Robot = $(config.robotId)")
    end

    return isRobotExisting(config.robotId)
end


"""
$(SIGNATURES)
Get a specific robot given a user ID and robot ID. Will retrieve config.robotId by default.
Return: The robot for the provided user ID and robot ID.
"""
function getRobot(robotId::String)::RobotResponse
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end

    url = "$(config.apiEndpoint)/$(format(robotEndpoint, config.userId, robotId))"
    response = @mock _sendRestRequest(config, HTTP.get, url)
    body = String(response.body)
    if(response.status != 200)
        error("Error getting robot, received $(response.status) with body '$body'.")
    end
    return JSON2.read(body, RobotResponse)
end

"""
$(SIGNATURES)
Get a specific robot given a user ID and robot ID. Will retrieve config.robotId by default.
Return: The robot for the provided user ID and robot ID.
"""
function getRobot()::RobotResponse
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end

    if config.robotId == ""
        error("Your config doesn't have a robot specified, please attach your config to a valid robot by setting the robotId field. Robot = $(config.robotId)")
    end

    return getRobot(config.robotId)
end

"""
$(SIGNATURES)
Create a robot in Synchrony and associate it with the given user.
Return: Returns the created robot.
"""
function addRobot(robot::RobotRequest)::RobotResponse
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    url = "$(config.apiEndpoint)/$(format(robotEndpoint, config.userId, robot.id))"
    response = @mock _sendRestRequest(config, HTTP.post, url, data=JSON.json(robot))
    if(response.status != 200)
        error("Error creating robot, received $(response.status) with body '$(String(response.body))'.")
    end
    return _unmarshallWithLinks(String(response.body), RobotResponse)
end

"""
$(SIGNATURES)
Update a robot.
Return: The updated robot from the service.
"""
function updateRobot(robot::RobotRequest)::RobotResponse
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    url = "$(config.apiEndpoint)/$(format(robotEndpoint, config.userId, robot.id))"
    response = @mock _sendRestRequest(config, HTTP.put, url, data=JSON.json(robot))
    if(response.status != 200)
        error("Error updating robot, received $(response.status) with body '$(String(response.body))'.")
    end
    return _unmarshallWithLinks(String(response.body), RobotResponse)
end

"""
$(SIGNATURES)
Delete a robot given a robot ID.
Return: The deleted robot.
"""
function deleteRobot(robotId::String)::RobotResponse
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    url = "$(config.apiEndpoint)/$(format(robotEndpoint, config.userId, robotId))"
    response = @mock _sendRestRequest(config, HTTP.delete, url)
    if(response.status != 200)
        error("Error deleting robot, received $(response.status) with body '$(String(response.body))'.")
    end
    return _unmarshallWithLinks(String(response.body), RobotResponse)
end

"""
$(SIGNATURES)
Will retrieve the robot configuration (user settings) for the given robot ID.
Return: The robot config for the provided user ID and robot ID.
"""
function getRobotConfig(robotId::String)::String
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    url = "$(config.apiEndpoint)/$(format(robotEndpoint, config.userId, robotId))/config"
    response = @mock _sendRestRequest(config, HTTP.get, url)
    if(response.status != 200 && response.status != 204)
        error("Error getting robot, received $(response.status) with body '$(String(response.body))'.")
    end
    return String(response.body)
end

"""
$(SIGNATURES)
Will retrieve the robot configuration (user settings) for the default robot ID.
Return: The robot config for the provided user ID and robot ID.
"""
function getRobotConfig()::String
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end

    if config.robotId == ""
        error("Your config doesn't have a robot specified, please attach your config to a valid robot by setting the robotId field. Robot = $(config.robotId)")
    end

    return getRobotConfig(config.robotId)
end

"""
$(SIGNATURES)
Update a robot configuration.
Return: The updated robot configuration from the service.
"""
function updateRobotConfig(robotId::String, robotConfig::String)::String
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    url = "$(config.apiEndpoint)/$(format(robotEndpoint, config.userId, robotId))/config"
    response = @mock _sendRestRequest(config, HTTP.put, url, data=JSON.json(robotConfig))
    if(response.status != 200)
        error("Error updating robot config, received $(response.status) with body '$(String(response.body))'.")
    end
    return String(response.body)
end

"""
$(SIGNATURES)
Update a robot configuration.
Return: The updated robot configuration from the service.
"""
function updateRobotConfig(robotConfig::String)::String
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    if config.robotId == ""
        error("Your config doesn't have a robot specified, please attach your config to a valid robot by setting the robotId field. Robot = $(config.robotId)")
    end

    return updateRobotConfig(config.robotId, robotConfig)
end
