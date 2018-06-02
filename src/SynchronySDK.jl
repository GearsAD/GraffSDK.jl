module SynchronySDK

# Imports
using Requests, JSON, Unmarshal
using Formatting
using Graphs
using DocStringExtensions

# Utility functions
"""
$(SIGNATURES)
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

include("./entities/User.jl")
include("./services/UserService.jl")

include("./entities/Robot.jl")
include("./services/RobotService.jl")

include("./entities/Session.jl")
include("./entities/Data.jl")
include("./services/DataHelpers.jl")
include("./services/SessionService.jl")

include("./services/VisualizationService.jl")
include("./entities/Cyphon.jl")

# Exported functions
function nodeDetail2ExVertex(nodeDetails::SynchronySDK.NodeDetailsResponse)::Graphs.ExVertex
    vert = Graphs.ExVertex(nodeDetails.sessionIndex, nodeDetails.name)
    vert.attributes = Graphs.AttributeDict()
    vert.attributes = nodeDetails.properties

    # populate the data container
    vert.attributes["data"] = nodeDetails.packed
    return vert
end

# Exports
export SynchronyConfig, ErrorResponse
export UserRequest, UserResponse, KafkaConfig, UserConfig, addUser, getUser, updateUser, deleteUser, getUserConfig
export RobotRequest, RobotResponse, RobotsResponse, getRobots, getRobot, addRobot, updateRobot, deleteRobot, getRobotConfig, updateRobotConfig
export SessionDetailsRequest, SessionDetailsResponse, addSession, getSessions, getSession, deleteSession, isSessionExisting, putReady
export BigDataElementRequest, BigDataEntryResponse, BigDataElementResponse
export getDataEntries, getDataElement, getRawDataElement, addDataElement, updateDataElement, addOrUpdateDataElement, deleteDataElement
export encodeJsonData, encodeBinaryData, readImageIntoDataRequest, isSafeToJsonSerialize
export NodeResponse, NodesResponse, BigDataElementResponse, NodeDetailsResponse, getNodes, getNode
export AddOdometryRequest, AddOdometryResponse, NodeResponseInfo, addOdometryMeasurement
export VariableRequest, addVariable
export FactorRequest, FactorBody, BearingRangeRequest, DistributionRequest, addFactor, addBearingRangeFactor
# For testing
export _unmarshallWithLinks
export nodeDetail2ExVertex
end
