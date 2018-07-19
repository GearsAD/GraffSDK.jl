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

# function show(io::IO, obj::RobotResponse)
#     print("\r\nRobot: \r\n - ID: $(obj.id)\r\n  - Name: $(obj.name)\r\n  - Desc: $(obj.description)\r\n  - Status: $(obj.status)")
# end

"""
A list of robots provided by the /robots request.
"""
struct RobotsResponse
    robots::Vector{RobotResponse}
    links::Dict{String, String}
end
