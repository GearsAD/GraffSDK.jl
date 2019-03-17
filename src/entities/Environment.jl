# import Base: show

"""
The structure used for environment requests.
"""
mutable struct EnvironmentRequest
  id::String
  name::String
  description::String
  status::String
end

"""
The structure returned when any environment requests are made.
"""
mutable struct EnvironmentResponse
  sessions::Vector{Dict{String, Any}}
  id::String
  name::String
  description::String
  createdTimestamp::String
  lastUpdatedTimestamp::String
end

function show(io::IO, r::EnvironmentResponse)
    println(io, "GraffSDK Environment:")
    println(io, " - ID: $(r.id)")
    println(io, "   - Name: $(r.name)")
    println(io, "   - Description: $(r.description)")
    println(io, "   - Sessions Associated: $(length(r.sessions)) sessions")
    println(io, "   - Created: $(r.createdTimestamp)")
    println(io, "   - Last Updated: $(r.lastUpdatedTimestamp)")
end
