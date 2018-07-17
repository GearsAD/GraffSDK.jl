module SynchronySDK

# Imports
using JSON, Unmarshal
using HTTP
using Formatting
using Graphs
using DocStringExtensions
using ProgressMeter

# Initial Include
include("./entities/SynchronySDK.jl")

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

"""
$SIGNATURES
Produces the authorization and sends the REST request.
"""
function _sendRestRequest(synchronyConfig::SynchronyConfig, verbFunction, url::String; data::String="", headers::Dict{String, String}=Dict{String, String}(), debug::Bool=false)::Requests.Response
    verbFunction(url, headers, body;
        aws_authorization=true,
        aws_service="execute-api",
        aws_region=synchronyConfig.region,
        aws_access_key_id=synchronyConfig.accessKey,
        aws_secret_access_key=synchronyConfig.secretKey)
end

# Includes
include("./services/StatusService.jl")
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
export getStatus
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
export visualizeSession
# For testing
export nodeDetail2ExVertex
end
