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
  links::Dict{String, String}
end

"""
The structure used to briefly describe a node in a response.
"""
mutable struct NodeResponse
    id::Int
    name::String
    links::Dict{String, String}
end

"""
The structure used to briefly describe a set of nodes in a response.
"""
mutable struct NodesResponse
    nodes::Vector{NodeResponse}
    links::Dict{String, String}
end


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
    name::String
    properties::Dict{String, Any}
    packed::Any
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
