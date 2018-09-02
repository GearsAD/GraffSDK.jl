"""
Body of a request for creating or updating a data element.
"""
mutable struct BigDataElementRequest
    id::String
    sourceName::String
    description::String
    data::String
    mimeType::String
    BigDataElementRequest(id::String, sourceName::String, description::String, data::String, mimeType::String="application/octet-stream") = new(id, sourceName, description, data, mimeType)
end

"""
Summary of data entry returned from request.
"""
mutable struct BigDataEntryResponse
    id::String
    nodeId::Nullable{Int}
    sourceName::String
    description::String
    mimeType::String
    lastSavedTimestamp::String
    links::Dict{String, String}
end

"""
Complete data element response (including data).
"""
mutable struct BigDataElementResponse
    id::String
    nodeId::Nullable{Int}
    sourceName::String
    description::String
    data::String
    mimeType::String
    lastSavedTimestamp::String
    links::Dict{String, String}
end
