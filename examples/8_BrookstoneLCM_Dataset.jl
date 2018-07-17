# In this example we are going to ingest and solve a real dataset from a Brookstone rover.

# 0. We need additional libraries to ingest the raw LCM datafile. Minimal installs, definitely worth the data :)
#  - Note that a full Caesar install will give all these to you (later examples), but in case you don't have them, let's go through the steps.
# Pkg.add("LCMCore")
# Pkg.clone("https://github.com/JuliaRobotics/CaesarLCMTypes.jl.git") # For poses

using LCMCore, CaesarLCMTypes
using JSON
using SynchronySDK

# 1. Import the initialization code.
cd(joinpath(Pkg.dir("SynchronySDK"),"examples"))
include("0_Initialization.jl")
# 1a. Constants
robotId = "Brookstone"
sessionId = "Hackathon8"
synchronyConfig = loadConfig("synchronyConfig_NaviEast_Internal.json")

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

# Adding the data!

mutable struct RuntimeInfo
    synchronyConfig::SynchronyConfig
    robotId::String
    sessionId::String
end

# 5. Set up the LCM callbacks
function lcm_NewOdoAvailable(channel, msg::brookstone_supertype_t, runtimeInfo::RuntimeInfo)
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
    nodeLabel = response.variable.label
    newNode = getNode(synchronyConfig, robotId, sessionId, nodeLabel)
    nodeId = newNode.id
    # Make a request payload
    dataElementRequest = BigDataElementRequest("CamImage", "Mongo", "Brookstone camera data for timestamp $(factor.utime)", base64encode(img.data), "image/jpeg")
    @show dataElementRequest
    error("NOPE!")
    #   # add the data to the database
    addOrUpdateDataElement(synchronyConfig, robotId, sessionId, nodeId, dataElementRequest)
end

# Not ideal but i need these things.
runtimeInfo = RuntimeInfo(synchronyConfig, robotId, sessionId)

cd(Pkg.dir("SynchronySDK"))
lcm = LCMLog("examples/data/brookstone_3.lcmlog")
subscribe(lcm, "BROOKSTONE_ROVER", (c,m)->lcm_NewOdoAvailable(c,m, runtimeInfo), brookstone_supertype_t)
# subscribe(lcm, "BROOKSTONE_NEW_FACTOR", (c,m) -> newFactor_Callback(c, m, runtimeInfo), generic_factor_t)
# subscribe(lcm, "BROOKSTONE_CAM_IMAGE", (c,m)->keyframe_Callback(c,m, synchronyConfig, nodehist), image_t)

# Run while there is data
while handle(lcm)
end

# KAMEHAMEHA :D
# NOW PLAY THIS: https://www.youtube.com/watch?v=UT9w0PGykZ0
# How awesome is that?

# Let's take a look at the data:
visualizeSession(synchronyConfig, robotId, sessionId, "CamImage")
