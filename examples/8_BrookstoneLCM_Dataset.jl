# In this example we are going to ingest and solve a real dataset from a Brookstone rover.

# 0. We need additional libraries to ingest the raw LCM datafile. Minimal installs, definitely worth the data :)
#  - Note that a full Caesar install will give all these to you (later examples), but in case you don't have them, let's go through the steps.
# ] then add LCMCore#v0.5.1 #Unsafe arrays don't work yet.
# ] then dev CaesarLCMTypes

using LCMCore, CaesarLCMTypes
using JSON
using GraffSDK

# 1. Import the initialization code.
cd(joinpath(dirname(pathof(GraffSDK)), "..", "examples"))
# 1a. Constants
graffConfig = loadGraffConfig("synchronyConfig.json")
graffConfig.sessionId = "Hackathon808"
graffConfig.robotId = "Brookstone"

# 2. Confirm that the robot already exists, create if it doesn't.
println(" - Creating or retrieving robot '$(graffConfig.robotId)'...")
robot = nothing
if(GraffSDK.isRobotExisting())
    println(" -- Robot '$(graffConfig.robotId)' already exists, retrieving it...")
    robot = getRobot()
else
    # Create a new one
    println(" -- Robot '$(graffConfig.robotId)' doesn't exist, creating it...")
    newRobot = RobotRequest(graffConfig.robotId, "My New Bot", "Description of my neat robot", "Active")
    robot = addRobot(graffConfig, newRobot)
end

# 3. Create or retrieve the session.
# Get sessions, if it already exists, add to it.
println(" - Creating or retrieving data session '$(graffConfig.sessionId)' for robot...")
session = nothing
if(GraffSDK.isSessionExisting())
    println(" -- Session '$(graffConfig.sessionId)' already exists for robot '$(graffConfig.robotId)', retrieving it...")
    session = getSession()
else
    # Create a new one
    println(" -- Session '$(graffConfig.sessionId)' doesn't exist for robot '$(graffConfig.robotId)', creating it...")
    newSessionRequest = SessionDetailsRequest(graffConfig.sessionId, "Brookstone test dataset - driving in a loop around the Work DoneGin.", "Pose2")
    session = addSession(newSessionRequest)
end
println(session)

# Adding the data!

# 5. Set up the LCM callbacks
function lcm_NewOdoAvailable(channel, msg::brookstone_supertype_t, graffConfig::SynchronyConfig)
    # @show variable = msg.newvariable
    factor = msg.newfactor
    img = msg.img
    # Factor
    dataFrame = JSON.parse(String(factor.data))
    measurement = Float64.(dataFrame["meas"])
    @show pOdo = Float64.(reshape(dataFrame["podo"], 3, 3))
    newOdometryMeasurement = AddOdometryRequest(measurement, pOdo)
    @time @show response = addOdometryMeasurement(newOdometryMeasurement)

    # Image
    # TODO: Finding the ID for the node - this shouldn't be necessary! Fix once we have response.variable.id
    # nodeLabel = response.variable.label
    # newNode = getNode(graffConfig, robotId, sessionId, nodeLabel)
    # nodeId = newNode.id
    # # Make a request payload
    # dataElementRequest = BigDataElementRequest("CamImage", "Mongo", "Brookstone camera data for timestamp $(factor.utime)", base64encode(img.data), "image/jpeg")
    #   # add the data to the database
    # addOrUpdateDataElement(graffConfig, robotId, sessionId, nodeId, dataElementRequest)
end

lcmLog = LCMLog("data/brookstone_3.lcmlog")
subscribe(lcmLog, "BROOKSTONE_ROVER", (c,m)->lcm_NewOdoAvailable(c,m, graffConfig), brookstone_supertype_t)
# subscribe(lcm, "BROOKSTONE_NEW_FACTOR", (c,m) -> newFactor_Callback(c, m, runtimeInfo), generic_factor_t)
# subscribe(lcm, "BROOKSTONE_CAM_IMAGE", (c,m)->keyframe_Callback(c,m, graffConfig, nodehist), image_t)

# Run while there is data
while handle(lcmLog)
end

# KAMEHAMEHA :D
# NOW PLAY THIS: https://www.youtube.com/watch?v=UT9w0PGykZ0
# How awesome is that?

# Let's take a look at the data:
visualizeSession(graffConfig, robotId, sessionId, "CamImage")
