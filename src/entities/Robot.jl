
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
  links::Dict{String, String}
  createdTimestamp::String
  lastUpdatedTimestamp::String
end

"""
A list of robots provided by the /robots request.
"""
struct RobotsResponse
    robots::Vector{RobotModel}
    links::Dict{String, String}
end
