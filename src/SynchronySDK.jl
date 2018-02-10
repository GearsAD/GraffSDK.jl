module SynchronySDK

# Imports
using Requests, JSON, Unmarshal
using Formatting

# Includes
include("./entities/SynchronySDK.jl")

include("./entities/Auth.jl")
include("./services/AuthService.jl")

include("./entities/User.jl")
include("./services/UserService.jl")

include("./entities/Session.jl")
include("./entities/Robot.jl")
include("./entities/Cyphon.jl")

# Exports
export SynchronyConfig
export AuthRequest, AuthResponse, authenticate, refreshToken
export UserRequest, UserResponse, KafkaConfig, UserConfig, ErrorResponse, createUser, getUser, updateUser, deleteUser, getUserConfig

# Internal definitions
robotsEndpoint = "api/v0/users/{1}/robots/{2}"
sessionsEndpoint = "api/v0/robots/{1}/sessions/{2}"
nodeEndpoint = "api/v0/robots/{1}/sessions/{2}/nodes/{3}"
dataEndpoint = "api/v0/robots/{1}/sessions/{2}/nodes/{3}/bigData/{4}"

end
