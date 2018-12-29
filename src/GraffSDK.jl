module GraffSDK

# Imports
using HTTP, JSON, Unmarshal
using Graphs
using DocStringExtensions
using ProgressMeter
using Formatting
using Dates
using Nullables

import Base.show

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
Load a config file from a file name, internally calls setGraffConfig, and returns the config data.
"""
function loadGraffConfig(filename::String)::SynchronyConfig
    if !isfile(filename)
        error("Cannot locate the configuration file '$filename'. Please check that it exists.")
    end
    configFile = open(filename)
    configData = JSON.parse(read(configFile, String))
    close(configFile)
    config = Unmarshal.unmarshal(SynchronyConfig, configData)
    setGraffConfig(config)
    return config
end

"""
    $(SIGNATURES)
Set the configuration that the GraffSDK should use.
"""
function setGraffConfig(graffConfig::SynchronyConfig):Nothing
    global __graffConfig
    __graffConfig = graffConfig
    return nothing
end
"""
    $(SIGNATURES)
Get the current GraffSDK configuration.
"""
function getGraffConfig()::Union{Nothing, SynchronyConfig}
    return __graffConfig
end

# Includes
include("./entities/User.jl")
include("./services/UserService.jl")

include("./entities/Robot.jl")
include("./services/RobotService.jl")

include("./entities/Session.jl")
include("./entities/Data.jl")
include("./services/DataHelpers.jl")
include("./services/SessionService.jl")
include("./services/StatusService.jl")

include("./entities/User.jl")
include("./services/UserService.jl")
# include("./services/VisualizationService.jl")

include("./entities/Cyphon.jl")

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
function _sendRestRequest(synchronyConfig::SynchronyConfig, verbFunction, url::String; data::String="", headers::Dict{String, String}=Dict{String, String}(), debug::Bool=false)::HTTP.Response
    if length(headers) == 0 && data == "" # Special case for HTTP.delete
        verbFunction(url;
            aws_authorization=true,
            aws_service="execute-api",
            aws_region=synchronyConfig.region,
            aws_access_key_id=synchronyConfig.accessKey,
            aws_secret_access_key=synchronyConfig.secretKey)
    else
        verbFunction(url, headers, data;
            aws_authorization=true,
            aws_service="execute-api",
            aws_region=synchronyConfig.region,
            aws_access_key_id=synchronyConfig.accessKey,
            aws_secret_access_key=synchronyConfig.secretKey)
    end
end

# Exports
export SynchronyConfig, ErrorResponse
export loadGraffConfig, setGraffConfig, getGraffConfig
export getStatus, printStatus
export UserRequest, UserResponse, KafkaConfig, UserConfig, addUser, getUser, updateUser, deleteUser, getUserConfig
export RobotRequest, RobotResponse, RobotsResponse, getRobots, isRobotExisting, getRobot, addRobot, updateRobot, deleteRobot, getRobotConfig, updateRobotConfig
export SessionsResponse, SessionResponse, SessionDetailsRequest, SessionDetailsResponse, addSession, getSessions, isSessionExisting, getSession, deleteSession, putReady, requestSessionSolve
export getSessionBacklog, getSessionDeadQueueLength, getSessionDeadQueueMessages, reprocessDeadQueueMessages, deleteDeadQueueMessages
export BigDataElementRequest, BigDataEntryResponse, BigDataElementResponse
export getDataEntries, getData, getRawData, setData, deleteData
export exportSessionJld
export getLandmarks, getEstimates
export encodeJsonData, encodeBinaryData, readFileIntoDataRequest, isSafeToJsonSerialize
export NodeResponse, NodesResponse, BigDataElementResponse, NodeDetailsResponse, getNodes, ls, getNode
export AddOdometryRequest, AddOdometryResponse, NodeResponseInfo, addOdometryMeasurement
export VariableRequest, VariableResponse, BearingRangeRequest, BearingRangeResponse, DistributionRequest, FactorBody, FactorRequest, addVariable, addBearingRangeFactor, addFactor
# export VisualizationRequest, visualizeSession
# For testing
export _unmarshallWithLinks
export nodeDetail2ExVertex
end
