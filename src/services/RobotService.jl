include("../entities/Auth.jl")
include("../entities/Robot.jl")

robotsEndpoint = "api/v0/users/{1}/robots"
robotEndpoint = "api/v0/users/{1}/robots/{2}"

"""
    getRobots(config::SynchronyConfig, auth::AuthResponse, userId::String)::RobotsResponse
Gets all robots managed by the specified user.
Return: A vector of robots for a given user.
"""
function getRobots(config::SynchronyConfig, auth::AuthResponse, userId::String)::RobotsResponse
    url = "$(config.apiEndpoint):$(config.apiPort)/$(format(robotsEndpoint, userId))"
    response = get(url; headers = Dict("token" => auth.token))
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
    getRobot(config::SynchronyConfig, auth::AuthResponse, userId::String, robotId::String)::RobotResponse
Get a specific robot given a user ID and a robot ID.
Return: The robot for the provided user ID and robot ID.
"""
function getRobot(config::SynchronyConfig, auth::AuthResponse, userId::String, robotId::String)::RobotResponse
    url = "$(config.apiEndpoint):$(config.apiPort)/$(format(robotEndpoint, userId, robotId))"
    response = get(url; headers = Dict("token" => auth.token))
    if(statuscode(response) != 200)
        error("Error getting robot, received $(statuscode(response)) with body '$(readstring(response))'.")
    else
        return _unmarshallWithLinks(readstring(response), RobotResponse)
    end
end

"""
    createRobot(config::SynchronyConfig, auth::AuthResponse, userId::String, robot::RobotRequest)::RobotResponse
Create a robot in Synchrony and associate it with the given user.
Return: Returns the created robot.
"""
function createRobot(config::SynchronyConfig, auth::AuthResponse, userId::String, robot::RobotRequest)::RobotResponse
    url = "$(config.apiEndpoint):$(config.apiPort)/$(format(robotEndpoint, userId, robot.id))"
    response = post(url; headers = Dict("token" => auth.token), data=JSON.json(robot))
    if(statuscode(response) != 200)
        error("Error creating robot, received $(statuscode(response)) with body '$(readstring(response))'.")
    else
        return _unmarshallWithLinks(readstring(response), RobotResponse)
    end
end

"""
    updateRobot(config::SynchronyConfig, auth::AuthResponse, userId::String, robot::RobotRequest)::RobotResponse
Update a robot.
Return: The updated robot from the service.
"""
function updateRobot(config::SynchronyConfig, auth::AuthResponse, userId::String, robot::RobotRequest)::RobotResponse
    url = "$(config.apiEndpoint):$(config.apiPort)/$(format(robotEndpoint, userId, robot.id))"
    response = put(url; headers = Dict("token" => auth.token), data=JSON.json(robot))
    if(statuscode(response) != 200)
        error("Error updating robot, received $(statuscode(response)) with body '$(readstring(response))'.")
    else
        return _unmarshallWithLinks(readstring(response), RobotResponse)
    end
end

"""
    deleteRobot(config::SynchronyConfig, auth::AuthResponse, userId::String, robotId::String)::RobotResponse
Delete a robot given a robot ID.
Return: The deleted robot.
"""
function deleteRobot(config::SynchronyConfig, auth::AuthResponse, userId::String, robotId::String)::RobotResponse
    url = "$(config.apiEndpoint):$(config.apiPort)/$(format(robotEndpoint, userId, robotId))"
    response = delete(url; headers = Dict("token" => auth.token))
    if(statuscode(response) != 200)
        error("Error deleting robot, received $(statuscode(response)) with body '$(readstring(response))'.")
    else
        return _unmarshallWithLinks(readstring(response), RobotResponse)
    end
end
