include("../entities/Robot.jl")

robotsEndpoint = "api/v0/users/{1}/robots"
robotEndpoint = "api/v0/users/{1}/robots/{2}"

"""
    getRobots(config::SynchronyConfig)::RobotsResponse
Gets all robots managed by the specified user.
Return: A vector of robots for a given user.
"""
function getRobots(config::SynchronyConfig)::RobotsResponse
    url = "$(config.apiEndpoint):$(config.apiPort)/$(format(robotsEndpoint, config.userId))"
    response = get(url; headers = Dict())
    if(statuscode(response) != 200)
        error("Error getting robots, received $(statuscode(response)) with body '$(readstring(response))'.")
    else
        # Some manual effort done here because it's a vector response.
        rawRobots = JSON.parse(readstring(response))
        robots = RobotsResponse(Vector{RobotResponse}(), rawRobots["links"])
        for robot in rawRobots["robots"]
            robot = _unmarshallWithLinks(JSON.json(robot), RobotResponse)
            push!(robots.robots, robot)
        end
        return robots
    end
end

"""
    isRobotExisting(config::SynchronyConfig, robotId::String)::Bool
Return: Returns true if the robot exists already.
"""
function isRobotExisting(config::SynchronyConfig, robotId::String)::Bool
    robots = getRobots(config)
    return robotId in map(robot -> robot.id, robots.robots)
end

"""
    getRobot(config::SynchronyConfig, robotId::String)::RobotResponse
Get a specific robot given a user ID and robot ID. Will retrieve config.robotId by default.
Return: The robot for the provided user ID and robot ID.
"""
function getRobot(config::SynchronyConfig, robotId::String)::RobotResponse
    url = "$(config.apiEndpoint):$(config.apiPort)/$(format(robotEndpoint, config.userId, robotId))"
    response = get(url; headers = Dict())
    if(statuscode(response) != 200)
        error("Error getting robot, received $(statuscode(response)) with body '$(readstring(response))'.")
    else
        return _unmarshallWithLinks(readstring(response), RobotResponse)
    end
end

"""
    createRobot(config::SynchronyConfig, robot::RobotRequest)::RobotResponse
Create a robot in Synchrony and associate it with the given user.
Return: Returns the created robot.
"""
function createRobot(config::SynchronyConfig, robot::RobotRequest)::RobotResponse
    url = "$(config.apiEndpoint):$(config.apiPort)/$(format(robotEndpoint, config.userId, robot.id))"
    response = post(url; headers = Dict(), data=JSON.json(robot))
    if(statuscode(response) != 200)
        error("Error creating robot, received $(statuscode(response)) with body '$(readstring(response))'.")
    else
        return _unmarshallWithLinks(readstring(response), RobotResponse)
    end
end

"""
    updateRobot(config::SynchronyConfig, robot::RobotRequest)::RobotResponse
Update a robot.
Return: The updated robot from the service.
"""
function updateRobot(config::SynchronyConfig, robot::RobotRequest)::RobotResponse
    url = "$(config.apiEndpoint):$(config.apiPort)/$(format(robotEndpoint, config.userId, robot.id))"
    response = Requests.put(url; headers = Dict(), data=JSON.json(robot))
    if(statuscode(response) != 200)
        error("Error updating robot, received $(statuscode(response)) with body '$(readstring(response))'.")
    else
        return _unmarshallWithLinks(readstring(response), RobotResponse)
    end
end

"""
    deleteRobot(config::SynchronyConfig, robotId::String)::RobotResponse
Delete a robot given a robot ID.
Return: The deleted robot.
"""
function deleteRobot(config::SynchronyConfig, robotId::String)::RobotResponse
    url = "$(config.apiEndpoint):$(config.apiPort)/$(format(robotEndpoint, config.userId, robotId))"
    response = delete(url; headers = Dict())
    if(statuscode(response) != 200)
        error("Error deleting robot, received $(statuscode(response)) with body '$(readstring(response))'.")
    else
        return _unmarshallWithLinks(readstring(response), RobotResponse)
    end
end

"""
    getRobotConfig(config::SynchronyConfig, robotId::String)::Dict{Any, Any}
Will retrieve the robot configuration (user settings) for the given robot ID.
Return: The robot config for the provided user ID and robot ID.
"""
function getRobotConfig(config::SynchronyConfig, robotId::String)::Dict{Any, Any}
    url = "$(config.apiEndpoint):$(config.apiPort)/$(format(robotEndpoint, config.userId, robotId))/config"
    response = get(url; headers = Dict())
    if(statuscode(response) != 200)
        error("Error getting robot, received $(statuscode(response)) with body '$(readstring(response))'.")
    else
        return JSON.parse(readstring(response))
    end
end

"""
    updateRobotConfig(config::SynchronyConfig, robotId::String, robotConfig::Dict{String, String})::Dict{Any, Any}
Update a robot configuration.
Return: The updated robot configuration from the service.
"""
function updateRobotConfig(config::SynchronyConfig, robotId::String, robotConfig::Dict{String, String})::Dict{Any, Any}
    url = "$(config.apiEndpoint):$(config.apiPort)/$(format(robotEndpoint, config.userId, robotId))/config"
    response = Requests.put(url; headers = Dict(), data=JSON.json(robotConfig))
    if(statuscode(response) != 200)
        error("Error updating robot config, received $(statuscode(response)) with body '$(readstring(response))'.")
    else
        return JSON.parse(readstring(response))
    end
end
