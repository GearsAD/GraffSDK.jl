module GraffSDK

# Imports
using HTTP, JSON2, JSON, Unmarshal
using Graphs
using DocStringExtensions
using ProgressMeter
using Formatting
using Dates
using Requires

import Base.show

curApiVersion = "v0b"

# Base includes
include("./entities/GraffSDK.jl")

# Utility functions
"""
$(SIGNATURES)
Internal fix for Unmarshal not being able to deserialize dictionaries.
https://github.com/lwabeke/Unmarshal.jl/issues/9
This still seems to be an issue even with 0.1.1 of Unmarshal.
"""
function _unmarshallWithLinks(responseBody::String, t::Type)
    j = JSON.parse(responseBody)
    links = j["links"]
    j["links"] = Dict{String,String}()
    unmarshalled = Unmarshal.unmarshal(t, j)
    unmarshalled.links = links
    return unmarshalled
end

"""
    $(SIGNATURES)
Load a config, internally calls setGraffConfig, and returns the config data.
1. If 'GRAFFCONFIG' is set as environment variable, use that as the config
2. Otherwise if no filename specified, use '~/.graffsdk.json'
3. Otherwise if filename specified, use that
"""
function loadGraffConfig(;filename::String="",
                        consoleParams::Vector{Symbol}=Symbol[]  )::GraffConfig
    #
    configData = ""
    if haskey(ENV, "graffconfig")
        configData = ENV["graffconfig"]
    else
        if filename == ""
            !haskey(ENV, "HOME") && error("Can't find a 'HOME' environment variable, please specify one before it can be used to locate the default configuration file")
            @info "Using default Graff config location (~/.graffsdk.json). If you want to load a different config file, please specify in parameter or environment variable 'graffconfig' not set."
            filename = ENV["HOME"]*"/.graffsdk.json"
        end
        if !isfile(filename)
            error("Cannot locate the configuration file '$filename'. Please check that it exists.")
        end
        configFile = open(filename)
        configData = read(configFile, String)
        close(configFile)
    end
    config = JSON2.read(configData, GraffConfig)

    :apiEndpoint in consoleParams ? (println("API Endpoint: "); config.apiEndpoint = readline(stdin);) : nothing
    :accessKey in consoleParams ? (println("Access Key: "); config.accessKey = readline(stdin);) : nothing
    :secretKey in consoleParams ? (println("Secret Key: "); config.secretKey = readline(stdin);) : nothing
    :region in consoleParams ? (println("region: "); config.region = readline(stdin);) : nothing
    :userId in consoleParams ? (println("User ID: "); config.userId = readline(stdin);) : nothing
    :robotId in consoleParams ? (println("Robot ID: "); config.robotId = readline(stdin);) : nothing
    :sessionId in consoleParams ? (println("Session ID: "); config.sessionId = readline(stdin);) : nothing

    setGraffConfig(config)
    return config
end

"""
    $(SIGNATURES)
Set the configuration that the GraffSDK should use.
"""
function setGraffConfig(graffConfig::GraffConfig):Nothing
    global __graffConfig
    __graffConfig = graffConfig
    return nothing
end
"""
    $(SIGNATURES)
Get the current GraffSDK configuration.
"""
function getGraffConfig()::Union{Nothing, GraffConfig}
    return __graffConfig
end

# Includes
include("./entities/User.jl")
include("./services/UserService.jl")

include("./entities/Robot.jl")
include("./services/RobotService.jl")

include("./entities/Data.jl")
include("./entities/Session.jl")
include("./entities/Factor.jl")

include("./services/DataHelpers.jl")
include("./services/SessionService.jl")
include("./services/StatusService.jl")
include("./services/QueueService.jl")



include("./services/HelperFunctionService.jl")

# Exported functions
function nodeDetail2ExVertex(nodeDetails::GraffSDK.NodeDetailsResponse)::Graphs.ExVertex
    vert = Graphs.ExVertex(nodeDetails.sessionIndex, nodeDetails.name)
    vert.attributes = Graphs.AttributeDict()
    vert.attributes = nodeDetails.properties

    # populate the data container
    vert.attributes["data"] = nodeDetails.packed
    return vert
end

"""
$SIGNATURES
Produces the authorization and sends the REST request.
"""
function _sendRestRequest(config::GraffConfig, verbFunction, url::String; data::Union{String, Vector{UInt8}}="", headers::Dict{String, String}=Dict{String, String}(), debug::Bool=false)::HTTP.Response
    if length(headers) == 0 && data == "" # Special case for HTTP.delete
        verbFunction(url;
            aws_authorization=true,
            aws_service="execute-api",
            aws_region=config.region,
            aws_access_key_id=config.accessKey,
            aws_secret_access_key=config.secretKey)
    else
        verbFunction(url, headers, data;
            aws_authorization=true,
            aws_service="execute-api",
            aws_region=config.region,
            aws_access_key_id=config.accessKey,
            aws_secret_access_key=config.secretKey)
    end
end

"""
$SIGNATURES
Standard handler for errors - tries to parse out an error of form {"error": ""}, produces generic error if can't.
"""
function _handleRestError(functionName::String, status::Int, body::String)
    try
        #TODO
    catch ex
        # Can't parse, show the whole error.
    end
end

# Exports
export GraffConfig, ErrorResponse
export loadGraffConfig, setGraffConfig, getGraffConfig
export getStatus, printStatus
export UserRequest, UserResponse, KafkaConfig, UserConfig, addUser, getUser, updateUser, deleteUser, getUserConfig
export RobotRequest, RobotResponse, RobotsResponse, getRobots, isRobotExisting, getRobot, addRobot, updateRobot, deleteRobot, getRobotConfig, updateRobotConfig
export SessionsResponse, SessionResponse, SessionDetailsRequest, SessionDetailsResponse, addSession, getSessions, isSessionExisting, getSession, deleteSession, putReady, requestSessionSolve
export getSessionBacklog, getSessionDeadQueueLength, getSessionDeadQueueMessages, reprocessDeadQueueMessages, deleteDeadQueueMessages
export BigDataElementRequest, BigDataEntryResponse, BigDataElementResponse
export getDataEntries, getSessionDataEntries, getData, getRawData, setData, deleteData
export exportSessionJld
export getLandmarks, getEstimates
export encodeJsonData, encodeBinaryData, readFileIntoDataRequest, isSafeToJsonSerialize
export NodeResponse, NodesResponse, BigDataElementResponse, NodeDetailsResponse, getVariables, ls, getVariable
export AddOdometryRequest, AddOdometryResponse, NodeResponseInfo, addOdometryMeasurement
export VariableRequest, VariableResponse, BearingRangeRequest, BearingRangeResponse, DistributionRequest, FactorBody, FactorRequest, addVariable, addBearingRangeFactor, addFactor
export FactorSummary, getVariableFactors

## REGION: Optional Add-Ins

# If you have include Mongoc, bring in local stores
function __init__()
    @require Mongoc="4fe8b98c-fc19-5c23-8ec2-168ff83495f2" begin
        @info "--- MongoC was included beforehand, so importing local caching extensions. Call setLocalCache(cache::LocalCache) to set up local caching..."

        include("./entities/LocalCache.jl")
        include("./services/LocalCache.jl")
        export LocalCache
        export setLocalCache, getLocalCache
        export forceOnlyLocalCache
    end
end

end
