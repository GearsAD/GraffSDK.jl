# tutorial on conventional 2D SLAM example
# This tutorial shows how to use some of the commonly used factor types
# This tutorial follows from the ContinuousScalar example from IncrementalInference
using Base
using JSON, Unmarshal
using SynchronySDK

# 0. Constants
userId = "NewUser"
robotId = "NewRobot"
sessionId = "TestHexagonalDrive10"

# 1. Get a Synchrony configuration
# Assume that you're running in local directory
configFile = open("synchronyConfig_Local.json")
configData = JSON.parse(readstring(configFile))
close(configFile)
synchronyConfig = Unmarshal.unmarshal(SynchronyConfig, configData)

# 2. Authorizing ourselves for requests
authRequest = AuthRequest(userId, "apiKey")
auth = authenticate(synchronyConfig, authRequest)

# 3. Initialize+create session.
newSession = SessionDetailsRequest(sessionId, "A test dataset demonstrating data ingestion for a wheeled vehicle driving in a hexagon.")
retSession = createSession(synchronyConfig, auth, userId, robotId, newSession)
@show retSession

# 2. Drive around in a hexagon
for i in 0:5
    deltaMeasurement = [10.0;0;pi/3]
    pOdo = Float64[[0.1 0 0] [0 0.1 0] [0 0 0.1]]
    newOdometryMeasurement = AddOdometryRequest(deltaMeasurement, pOdo)
    odoResponse = addOdometryMeasurement(synchronyConfig, auth, userId, robotId, sessionId, newOdometryMeasurement)
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
