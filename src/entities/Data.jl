mutable struct BigDataElementRequest
    id::String
    sourceName::String
    description::String
    data::String
    mimeType::String
end

mutable struct BigDataEntryResponse
    id::String
    sourceName::String
    description::String
    mimeType::String
    lastSavedTimestamp::String
    links::Dict{String, String}
end

mutable struct BigDataElementResponse
    id::String
    sourceName::String
    description::String
    data::String
    mimeType::String
    lastSavedTimestamp::String
    links::Dict{String, String}
end
