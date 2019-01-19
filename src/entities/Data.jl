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

function show(io::IO, c::BigDataElementRequest)
    println(io, "Graff Data Element Request: ID = $(c.id), MIME type = $(c.mimeType), length = $(length(c.data)), description = $(c.description)")
end

"""
Summary of data entry returned from request.
"""
mutable struct BigDataEntryResponse
    id::String
    sourceId::String
    nodeId::Union{Nothing, Int}
    sourceName::String
    description::String
    mimeType::String
    lastSavedTimestamp::String
    links::Dict{String, String}
end

function show(io::IO, c::BigDataEntryResponse)
    println(io, "Graff Data Entry Response: ID = $(c.id), MIME type = $(c.mimeType), description = $(c.description)")
end

"""
Complete data element response (including data).
"""
mutable struct BigDataElementResponse
    id::String
    sourceId::String
    nodeId::Union{Nothing, Int}
    sourceName::String
    description::String
    data::String
    mimeType::String
    lastSavedTimestamp::String
    links::Dict{String, String}
end

function show(io::IO, c::BigDataElementResponse)
    println(io, "Graff Data Element Response: ID = $(c.id), MIME type = $(c.mimeType), length = $(length(c.data)), description = $(c.description)")
end
