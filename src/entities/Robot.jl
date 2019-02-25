# import Base: show

"""
The structure used for robot requests.
"""
mutable struct RobotRequest
  id::String
  name::String
  description::String
  status::String
end

"""
The structure returned when any robot requests are made.
"""
mutable struct RobotResponse
  robotId::String
  userId::Union{Nothing, String}
  status::String
  id::String
  name::String
  description::String
  createdTimestamp::String
  lastUpdatedTimestamp::String
  links::Dict{String, Any}
end

function show(io::IO, r::RobotResponse)
    println(io, "GraffSDK Robot:")
    println(io, " - ID: $(r.id)")
    println(io, "   - Name: $(r.name)")
    println(io, "   - Description: $(r.description)")
    println(io, "   - Status: $(r.status)")
    println(io, "   - Created: $(r.createdTimestamp)")
    println(io, "   - Last Updated: $(r.lastUpdatedTimestamp)")
end
