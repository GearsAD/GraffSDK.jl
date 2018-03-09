# tutorial on conventional 2D SLAM example
# This tutorial shows how to use some of the commonly used factor types
# This tutorial follows from the ContinuousScalar example from IncrementalInference
using Base
using JSON, Unmarshal
using SynchronySDK

# 0. Constants
robotId = "NewRobot14"
sessionId = "HexagonalDrive15"

# 1. Get a Synchrony configuration
# Assume that you're running in local directory
cd("/home/gearsad/.julia/v0.6/SynchronySDK/examples")
configFile = open("synchronyConfig_Local.json")
configData = JSON.parse(readstring(configFile))
close(configFile)
synchronyConfig = Unmarshal.unmarshal(SynchronyConfig, configData)

# 2. Confirm that the robot already exists, create if it doesn't.
robot = nothing
if(SynchronySDK.isRobotExisting(synchronyConfig, robotId))
    println(" --- Robot '$robotId' already exists, retrieving it...")
    robot = getRobot(synchronyConfig, robotId)
else
    # Create a new one
    println(" --- Robot '$robotId' doesn't exist, creating it...")
    newRobot = RobotRequest(robotId, "My New Bot", "Description of my neat robot", "Active")
    robot = createRobot(synchronyConfig, newRobot)
end
println(robot)

# 3. Create or retrieve the session.
# Get sessions, if it already exists, add to it.
session = nothing
if(SynchronySDK.isSessionExisting(synchronyConfig, robotId, sessionId))
    println(" --- Session '$sessionId' already exists for robot '$robotId', retrieving it...")
    session = getSession(synchronyConfig, robotId, sessionId)
else
    # Create a new one
    println(" --- Session '$sessionId' doesn't exist for robot '$robotId', creating it...")
    newSessionRequest = SessionDetailsRequest(sessionId, "A test dataset demonstrating data ingestion for a wheeled vehicle driving in a hexagon.")
    session = createSession(synchronyConfig, robotId, newSessionRequest)
end
println(session)

# 3. Drive around in a hexagon
for i in 0:5
    deltaMeasurement = [10.0;0;pi/3]
    pOdo = Float64[[0.1 0 0] [0 0.1 0] [0 0 0.1]]
    newOdometryMeasurement = AddOdometryRequest(deltaMeasurement, pOdo)
    odoResponse = addOdometryMeasurement(synchronyConfig, robotId, sessionId, newOdometryMeasurement)
end

# 3. Now let's get all the nodes for the session.


# 3.
# # Graphs.plot(fg.g)
# isInitialized(fg, :x5)
#
#
#
# ensureAllInitialized!(fg)
#
#
# using RoMEPlotting
#
# drawPoses(fg)
#
#
# getVal(fg, :x0)
# v = getVert(fg, :x0)
# getVal(v)
#
# importall CloudGraphs
#
# exvid = fg.IDs[:x0]
# neoID = fg.cgIDs[exvid]
# cvr = CloudGraphs.get_vertex(fg.cg, neoID, false)
# exv = CloudGraphs.cloudVertex2ExVertex(cvr)
# getVal(exv)
# # getData(exv)
#
#
# getData(fg.g.vertices[1])
#
#
# tree = wipeBuildNewTree!(fg)
# # inferOverTree!(fg, tree)
# inferOverTreeR!(fg, tree)
#
#
#
#
#
# using RoMEPlotting, Gadfly
#
#
#
#
#
# pl = plotKDE(fg, [:x0; :x1; :x2; :x3; :x4; :x5; :x6]);
#
# Gadfly.draw(PDF("tmpX0123456.pdf", 15cm, 15cm), pl)
#
# @async run(`evince tmpX0123456.pdf`)
#
#
#
# # pl = drawPoses(fg)
# pl = drawPosesLandms(fg)
# Gadfly.draw(PDF("tmpPosesFg.pdf", 15cm, 15cm), pl)
# @async run(`evince tmpPosesFg.pdf`)
#
#
#
# tree = wipeBuildNewTree!(fg)
#
#
# @async Graphs.plot(tree.bt)
#
#
# @time inferOverTree!(fg, tree)
#
#
# # Graphs.plot(tree.bt)
#
# @async Graphs.plot(fg.g)
