robotsEndpoint = "api/v0/users/{1}/robots"
robotEndpoint = "api/v0/users/{1}/robots/{2}"

"""
$(SIGNATURES)
Gets all robots managed by the specified user.
Return: A vector of robots for a given user.
"""
function getRobots(config::SynchronyConfig)::RobotsResponse
    url = "$(config.apiEndpoint)/$(format(robotsEndpoint, config.userId))"
    response = @mock _sendRestRequest(config, HTTP.get, url)
    if(response.status != 200)
        error("Error getting robots, received $(response.status) with body '$(String(response.body))'.")
    end
    # Some manual effort done here because it's a vector response.
    rawRobots = JSON.parse(String(response.body))
    robots = RobotsResponse(Vector{RobotResponse}(), rawRobots["links"])
    for robot in rawRobots["robots"]
        robot = _unmarshallWithLinks(JSON.json(robot), RobotResponse)
        push!(robots.robots, robot)
    end
    return robots
end

"""
$(SIGNATURES)
Return: Returns true if the robot exists already.
"""
function isRobotExisting(config::SynchronyConfig, robotId::String)::Bool
    robots = getRobots(config)
    return robotId in map(robot -> robot.id, robots.robots)
end

"""
$(SIGNATURES)
Return: Returns true if the robot in the config exists already.
"""
function isRobotExisting(config::SynchronyConfig)::Bool
    if config.robotId == ""
        error("Your config doesn't have a robot specified, please attach your config to a valid robot by setting the robotId field. Robot = $(config.robotId)")
    end

    return isRobotExisting(config, config.robotId)
end


"""
$(SIGNATURES)
Get a specific robot given a user ID and robot ID. Will retrieve config.robotId by default.
Return: The robot for the provided user ID and robot ID.
"""
function getRobot(config::SynchronyConfig, robotId::String)::RobotResponse
    url = "$(config.apiEndpoint)/$(format(robotEndpoint, config.userId, robotId))"
    response = @mock _sendRestRequest(config, HTTP.get, url)
    if(response.status != 200)
        error("Error getting robot, received $(response.status) with body '$(response.body)'.")
    end
    return _unmarshallWithLinks(String(response.body), RobotResponse)
end

"""
$(SIGNATURES)
Get a specific robot given a user ID and robot ID. Will retrieve config.robotId by default.
Return: The robot for the provided user ID and robot ID.
"""
function getRobot(config::SynchronyConfig)::RobotResponse
    if config.robotId == ""
        error("Your config doesn't have a robot specified, please attach your config to a valid robot by setting the robotId field. Robot = $(config.robotId)")
    end

    return getRobot(config, config.robotId)
end

"""
$(SIGNATURES)
Create a robot in Synchrony and associate it with the given user.
Return: Returns the created robot.
"""
function addRobot(config::SynchronyConfig, robot::RobotRequest)::RobotResponse
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
function updateRobot(config::SynchronyConfig, robot::RobotRequest)::RobotResponse
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
function deleteRobot(config::SynchronyConfig, robotId::String)::RobotResponse
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
function getRobotConfig(config::SynchronyConfig, robotId::String)::Dict{Any, Any}
    url = "$(config.apiEndpoint)/$(format(robotEndpoint, config.userId, robotId))/config"
    response = @mock _sendRestRequest(config, HTTP.get, url)
    if(response.status != 200)
        error("Error getting robot, received $(response.status) with body '$(String(response.body))'.")
    end
    return JSON.parse(String(response.body))
end

"""
$(SIGNATURES)
Will retrieve the robot configuration (user settings) for the default robot ID.
Return: The robot config for the provided user ID and robot ID.
"""
function getRobotConfig(config::SynchronyConfig)::Dict{Any, Any}
    if config.robotId == ""
        error("Your config doesn't have a robot specified, please attach your config to a valid robot by setting the robotId field. Robot = $(config.robotId)")
    end

    return getRobotConfig(config, config.robotId)
end

"""
$(SIGNATURES)
Update a robot configuration.
Return: The updated robot configuration from the service.
"""
function updateRobotConfig(config::SynchronyConfig, robotId::String, robotConfig::Dict{String, String})::Dict{Any, Any}
    url = "$(config.apiEndpoint)/$(format(robotEndpoint, config.userId, robotId))/config"
    response = @mock _sendRestRequest(config, HTTP.put, url, data=JSON.json(robotConfig))
    if(response.status != 200)
        error("Error updating robot config, received $(response.status) with body '$(String(response.body))'.")
    end
    return JSON.parse(String(response.body))
end

"""
$(SIGNATURES)
Update a robot configuration.
Return: The updated robot configuration from the service.
"""
function updateRobotConfig(config::SynchronyConfig, robotConfig::Dict{String, String})::Dict{Any, Any}
    if config.robotId == ""
        error("Your config doesn't have a robot specified, please attach your config to a valid robot by setting the robotId field. Robot = $(config.robotId)")
    end

    return updateRobotConfig(config, config.robotId, robotConfig)
end
