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
  id::String
  name::String
  description::String
  status::String
  createdTimestamp::String
  lastUpdatedTimestamp::String
  links::Dict{String, String}
end

function show(io::IO, r::RobotResponse)
    println(io, "GraffSDK Robot:")
    println(io, " - ID: $(r.id)")
    println(io, " - Name: $(r.name)")
    println(io, " - Description: $(r.description)")
    println(io, " - Status: $(r.status)")
    println(io, " - Created: $(r.createdTimestamp)")
    println(io, " - Last Updated: $(r.lastUpdatedTimestamp)")
end

"""
A list of robots provided by the /robots request.
"""
struct RobotsResponse
    robots::Vector{RobotResponse}
    links::Dict{String, String}
end

function show(io::IO, r::RobotsResponse)
    println(io, "GraffSDK Robots (count = $(length(r.robots))):")
    for robot in r.robots
        print(io, " - $robot")
    end
end
