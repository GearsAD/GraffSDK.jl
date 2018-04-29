# In this example we are going to ingest and solve a real dataset from a Brookstone rover.

# 0. We need additional libraries to ingest the raw LCM datafile. Minimal installs, definitely worth the data :)
#  - Note that a full Caesar install will give all these to you (later examples), but in case you don't have them, let's go through the steps.
# Pkg.add("LCMCore")
# Pkg.clone("https://github.com/JuliaRobotics/CaesarLCMTypes.jl.git") # For poses

using LCMCore, CaesarLCMTypes
using JSON

# 1. Import the initialization code.
cd(joinpath(Pkg.dir("SynchronySDK"),"examples"))
include("0_Initialization.jl")
# 1a. Constants
robotId = "Brookstone"
sessionId = "Hackathon4"

# 2. Confirm that the robot already exists, create if it doesn't.
println(" - Creating or retrieving robot '$robotId'...")
robot = nothing
if(SynchronySDK.isRobotExisting(synchronyConfig, robotId))
    println(" -- Robot '$robotId' already exists, retrieving it...")
    robot = getRobot(synchronyConfig, robotId)
else
    # Create a new one
    println(" -- Robot '$robotId' doesn't exist, creating it...")
    newRobot = RobotRequest(robotId, "My New Bot", "Description of my neat robot", "Active")
    robot = addRobot(synchronyConfig, newRobot)
end
println(robot)

# 3. Create or retrieve the session.
# Get sessions, if it already exists, add to it.
println(" - Creating or retrieving data session '$sessionId' for robot...")
session = nothing
if(SynchronySDK.isSessionExisting(synchronyConfig, robotId, sessionId))
    println(" -- Session '$sessionId' already exists for robot '$robotId', retrieving it...")
    session = getSession(synchronyConfig, robotId, sessionId)
else
    # Create a new one
    println(" -- Session '$sessionId' doesn't exist for robot '$robotId', creating it...")
    newSessionRequest = SessionDetailsRequest(sessionId, "A test dataset demonstrating data ingestion for a wheeled vehicle driving in a hexagon.", "Pose2")
    session = addSession(synchronyConfig, robotId, newSessionRequest)
end
println(session)

mutable struct RuntimeInfo
    # utimeToLabel::Dict{Int64, String}
    # curNodeIndex::Int
    synchronyConfig::SynchronyConfig
    robotId::String
    sessionId::String
end


# mutable struct NodeHistory
#   nodeBag::Dict{Int64, generic_variable_t}
#   utimeDeque::Deque{Int64}
#   NodeHistory(;
#     nodeBag = Dict{Int64, generic_variable_t}()
#     utimeDeque = Deque{Int64}(10)
#   ) = new(nodeBag, utimeDeque)
# end

# 5. Set up the LCM callbacks
function lcm_NewOdoAvailable(channel, msg::brookstone_supertype_t, runtimeInfo::RuntimeInfo)
# @show msg
    # @show variable = msg.newvariable
    factor = msg.newfactor
    img = msg.img
    # Factor
    dataFrame = JSON.parse(String(factor.data))
    measurement = Float64.(dataFrame["meas"])
    pOdo = Float64.(reshape(dataFrame["podo"], 3, 3))
    newOdometryMeasurement = AddOdometryRequest(measurement, pOdo)
    @time response = addOdometryMeasurement(synchronyConfig, robotId, sessionId, newOdometryMeasurement)

    # Image
    # TODO: Finding the ID for the node - this shouldn't be necessary! Fix once we have response.variable.id
    @show nodeLabel = response.variable.label
    newNode = getNode(synchronyConfig, robotId, sessionId, nodeLabel)
    @show nodeId = newNode.id
    # Make a request payload
    dataElementRequest = BigDataElementRequest("Cam_$(factor.utime)", "Mongo", "Brookstone camera data for timestamp $(factor.utime)", base64encode(img.data), "image/jpeg")
    #   # add the data to the database
    addOrUpdateDataElement(synchronyConfig, robotId, sessionId, nodeId, dataElementRequest)
end

# function newFactor_Callback(channel, msg::generic_factor_t, runtimeInfo::RuntimeInfo)
#     @show runtimeInfo.curNodeIndex
#     @show msg.utime
#     measurement = Float64.(dataFrame["meas"])
#     pOdo = Float64.(reshape(dataFrame["podo"], 3, 3))
#     # pOdo = Float64[[0.1 0 0] [0 0.1 0] [0 0 0.1]]
#     # println(" - Measurement $i: Adding new odometry measurement '$deltaMeasurement'...")
#
#     newOdometryMeasurement = AddOdometryRequest(measurement, pOdo)
#     @time @show response = addOdometryMeasurement(synchronyConfig, robotId, sessionId, newOdometryMeasurement)
#
#     # @show msg
# end
#
# function keyframe_Callback(channel, msg::image_t, synchronyConfig) #, nodehist::NodeHistory)
#   timestamp = msg.utime
#
#   # Find the node for timestamp
#   # varlbl = nodehist.nodeBag[msg.utime].variablelabel
#
#   # get node to which the camera image must be added
#   exampleNode = getNode(synchronyConfig, robotId, sessionId, nodes.nodes[1].id)
#
#   # Make a request payload
#   dataElementRequest = BigDataElementRequest("GiveMeAnID", "Mongo", description, base64encode(msg.imgBytes), "image/jpeg")
#   # add the data to the database
#   addOrUpdateDataElement(synchronyConfig, robotId, sessionId, exampleNode.id, dataElementRequest)
#
#   nothing
# end


# mutable struct OverTheTop
#   index::Int
# end
#
# function (ott::OverTheTop)(channel, msg::image_t)
#     # @show msg
#     println("Writing image!")
#     fid = open("cam$(ott.index).jpg", "w")
#     write(fid, msg.data)
#     close(fid)
#     ott.index += 1
#     nothing
# end
#
# oo = OverTheTop(0)


# nodehist = NodeHistory()

# Not ideal but i need these things.
runtimeInfo = RuntimeInfo(synchronyConfig, robotId, sessionId)

cd(Pkg.dir("SynchronySDK"))
lcm = LCMLog("examples/data/brookstone_3.lcmlog")
subscribe(lcm, "BROOKSTONE_ROVER", (c,m)->lcm_NewOdoAvailable(c,m, runtimeInfo), brookstone_supertype_t)
# subscribe(lcm, "BROOKSTONE_NEW_FACTOR", (c,m) -> newFactor_Callback(c, m, runtimeInfo), generic_factor_t)
# subscribe(lcm, "BROOKSTONE_CAM_IMAGE", (c,m)->keyframe_Callback(c,m, synchronyConfig, nodehist), image_t)

while true
    handle(lcm)
end

# KAMEHAMEHA :D
# NOW PLACE THIS: https://www.youtube.com/watch?v=UT9w0PGykZ0
# How awesome is that?
