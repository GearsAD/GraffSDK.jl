struct BigDataElementRequest
    id::String
    sourceName::String
    description::String
    data::String
    mimeType::String
end

struct BigDataEntryResponse
    id::String
    sourceName::String
    description::String
    mimeType::String
    lastSavedTimestamp::String
    links::Dict{String, String}
end

struct BigDataElementResponse
    id::String
    sourceName::String
    description::String
    data::String
    mimeType::String
    lastSavedTimestamp::String
    links::Dict{String, String}
end
