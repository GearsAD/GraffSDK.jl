
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

struct NodeResponse
    id::Int
    name::String
    links::Dict{String, String}
end

struct BigDataElementResponse
    id::String
    sourceName::String
    description::String
    data::Nullable{Union{Vector{UInt8}, Dict{String, Any}}}
    mimeType::String
    lastSavedTimestamp::String
    links::Dict{String, String}
end

struct NodeDetailsResponse
    id::Int
    name::String
    properties::Dict{String, Any}
    packed::Any
    labels::Vector{String}
    bigData::Vector{BigDataElementResponse}
    links::Dict{String, String}
end
