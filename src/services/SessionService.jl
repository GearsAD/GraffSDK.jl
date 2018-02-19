include("../entities/Auth.jl")
include("../entities/Session.jl")

sessionsEndpoint = "api/v0/users/{1}/robots/{2]/sessions}"
sessionEndpoint = "api/v0/users/{1}/robots/{2}/sessions/{3}"

"""
    getSessions(config::SynchronyConfig, auth::AuthResponse, userId::String, robotId::String)::SessionsResponse
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

# """
#     getRobot(config::SynchronyConfig, auth::AuthResponse, userId::String, robotId::String)::RobotResponse
# Get a specific robot given a user ID and a robot ID.
# Return: The robot for the provided user ID and robot ID.
# """
# function getRobot(config::SynchronyConfig, auth::AuthResponse, userId::String, robotId::String)::RobotResponse
#     url = "$(config.apiEndpoint):$(config.apiPort)/$(format(robotEndpoint, userId, robotId))"
#     response = get(url; headers = Dict("token" => auth.token))
#     if(statuscode(response) != 200)
#         error("Error getting robot, received $(statuscode(response)) with body '$(readstring(response))'.")
#     else
#         return _unmarshallWithLinks(readstring(response), RobotResponse)
#     end
# end

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
