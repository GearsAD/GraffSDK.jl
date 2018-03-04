module SynchronySDK

# Imports
using Requests, JSON, Unmarshal
using Formatting

# Utility functions
"""
    _unmarshallWithLinks(responseBody::String, t::Type)
Internal fix for Unmarshal not being able to deserialize dictionaries.
https://github.com/lwabeke/Unmarshal.jl/issues/9
"""
function _unmarshallWithLinks(responseBody::String, t::Type)
    j = JSON.parse(responseBody)
    links = j["links"]
    delete!(j, "links")
    unmarshalled = Unmarshal.unmarshal(t, j)
    unmarshalled.links = links
    return unmarshalled
end

# Includes
include("./entities/SynchronySDK.jl")

include("./entities/Auth.jl")
include("./services/AuthService.jl")

include("./entities/User.jl")
include("./services/UserService.jl")

include("./entities/Robot.jl")
include("./services/RobotService.jl")

include("./entities/Session.jl")
include("./services/SessionService.jl")

include("./entities/Cyphon.jl")

# Exports
export SynchronyConfig, ErrorResponse
export AuthRequest, AuthResponse, authenticate, refreshToken
export UserRequest, UserResponse, KafkaConfig, UserConfig, createUser, getUser, updateUser, deleteUser, getUserConfig
export RobotRequest, RobotResponse, RobotsResponse, getRobots, getRobot, createRobot, updateRobot, deleteRobot
export SessionDetailsRequest, SessionDetailsResponse, createSession, getSessions, getSession
export NodeResponse, NodesResponse, BigDataElementResponse, NodeDetailsResponse, getNodes, getNode
export AddOdometryRequest, AddOdometryResponse, addOdometryMeasurement
# For testing
export _unmarshallWithLinks

end
