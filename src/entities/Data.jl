mutable struct BigDataElementRequest
    id::String
    sourceName::String
    description::String
    data::String
    mimeType::String
    BigDataElementRequest(id::String, sourceName::String, description::String, data::String, mimeType::String="application/octet-stream") = new(id, sourceName, description, data, mimeType)
end

mutable struct BigDataEntryResponse
    id::String
    nodeId::Nullable{Int}
    sourceName::String
    description::String
    mimeType::String
    lastSavedTimestamp::String
    links::Dict{String, String}
end

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
