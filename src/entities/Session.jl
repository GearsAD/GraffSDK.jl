# import Base: show

mutable struct SessionResponse
    id::String
    links::Dict{String, String}
end

mutable struct SessionsResponse
    sessions::Vector{SessionResponse}
    links::Dict{String, String}
end

"""
The structure used for detailed session requests.
"""
mutable struct SessionDetailsRequest
    id::String
    description::String
    initialPoseType::Nullable{String}
    SessionDetailsRequest(id::String, description::String; initialPoseType::String = nothing) = new(id, description, initialPoseType)
end

"""
The structure used for detailed session responses.
"""
mutable struct SessionDetailsResponse
    id::String
    description::String
    robotId::String
    userId::String
    nodeCount::Int
    createdTimestamp::String
    lastSolvedTimestamp::String # Can remove nullable as soon as we stabilize.
    isSolverEnabled::Int # If 1 then the ad-hoc solver will pick up on it, otherwise will ignore this session.
    links::Dict{String, String}
end

# function show(io::IO, obj::SessionDetailsResponse)
#     print("\r\nSession: \r\n - ID: $(obj.id)\r\n  - Description: $(obj.description)\r\n  - Node count: $(obj.nodeCount)")
# end

"""
The structure used to briefly describe a node in a response.
"""
mutable struct NodeResponse
    id::Int
    label::String
    links::Dict{String, String}
end

# function show(io::IO, obj::NodeResponse)
#     print("\r\nNode: \r\n - ID: $(obj.id)\r\n  - Name: $(obj.name)")
# end

"""
The structure used to briefly describe a set of nodes in a response.
"""
mutable struct NodesResponse
    nodes::Vector{NodeResponse}
    links::Dict{String, String}
end

# function show(io::IO, obj::NodesResponse)
#     print("\r\n$(obj.nodes)")
# end


"""
The structure used to return a complete big data element in a response.
"""
mutable struct BigDataElementResponse
    id::String
    sourceName::String
    description::String
    data::Nullable{Union{Vector{UInt8}, Dict{String, Any}}}
    mimeType::String
    lastSavedTimestamp::String
    links::Dict{String, String}
end

"""
The structure describing a complete node in a response.
"""
mutable struct NodeDetailsResponse
    id::Int
    label::String
    sessionIndex::Int
    properties::Dict{String, Any}
    packed::Dict{String, Any}
    labels::Vector{String}
    bigData::Vector{BigDataElementResponse}
    links::Dict{String, String}
end

"""
The structure describing a high-level add-odometry request.
"""
struct AddOdometryRequest
    timestamp::String
    deltaMeasurement::Vector{Float64}
    pOdo::Array{Float64, 2}
    N::Nullable{Int64}
    AddOdometryRequest(deltaMeasurement::Vector{Float64}, pOdo::Array{Float64, 2}) = new(string(Dates.Time(now(Dates.UTC))), deltaMeasurement, pOdo, nothing)
end

"""
The structure describing the response to the add-odometry request.
"""
struct AddOdometryResponse
end

struct VariableRequest
    label::String
    variableType::String
    N::Nullable{Int64}
    labels::Vector{String}
end

struct VariableResponse
end

struct DistributionRequest
    distType::String
    params::Vector{Float64}
end

"""
A 2D bearing range request body.
"""
struct BearingRangeRequest
    pose2Id::String
    point2Id::String
    bearing::DistributionRequest
    range::DistributionRequest
end

struct BearingRangeResponse
end
