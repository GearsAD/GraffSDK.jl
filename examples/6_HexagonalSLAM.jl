# tutorial on conventional 2D SLAM example
# This tutorial shows how to use some of the commonly used factor types
# This tutorial follows from the ContinuousScalar example from IncrementalInference
using Base
using JSON, Unmarshal
using SynchronySDK

# 0. Constants
robotId = "NewRobot"
sessionId = "HexagonalDrive"

# 1. Get a Synchrony configuration
# Assume that you're running in local directory
println(" - Retrieving Synchrony Configuration...")
cd(joinpath(Pkg.dir("SynchronySDK"),"examples"))
configFile = open("synchronyConfig_Local.json")
configData = JSON.parse(readstring(configFile))
close(configFile)
synchronyConfig = Unmarshal.unmarshal(SynchronyConfig, configData)

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
    robot = createRobot(synchronyConfig, newRobot)
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
    newSessionRequest = SessionDetailsRequest(sessionId, "A test dataset demonstrating data ingestion for a wheeled vehicle driving in a hexagon.")
    session = createSession(synchronyConfig, robotId, newSessionRequest)
end
println(session)

# 4. Drive around in a hexagon
println(" - Adding hexagonal driving pattern to session...")
for i in 0:5
    deltaMeasurement = [10.0;0;pi/3]
    pOdo = Float64[[0.1 0 0] [0 0.1 0] [0 0 0.1]]
    println(" - Measurement $i: Adding new odometry measurement '$deltaMeasurement'...")
    newOdometryMeasurement = AddOdometryRequest(deltaMeasurement, pOdo)
    @time odoResponse = addOdometryMeasurement(synchronyConfig, robotId, sessionId, newOdometryMeasurement)
end
#
# # 5. Now retrieve the dataset
# println(" - Retrieving all data for session $sessionId...")
@time nodes = getNodes(synchronyConfig, robotId, sessionId);
# println(" -- Node list:\r\n$nodes")

# By NeoID
node = getNode( synchronyConfig, robotId, sessionId, nodes.nodes[1].id);
# By Synchrony label
node = getNode( synchronyConfig, robotId, sessionId, nodes.nodes[1].label);

# 6. Now lets add a couple landmarks
# Ref: https://github.com/dehann/RoME.jl/blob/master/examples/Slam2dExample.jl#L35
newLandmark = VariableRequest("l1", "Point2", nothing, ["LANDMARK"])
response = addVariable(synchronyConfig, robotId, sessionId, newLandmark)
newBearingRangeFactor = BearingRangeRequest("x1", "l1",
                          DistributionRequest("Normal", Float64[0; 0.1]),
                          DistributionRequest("Normal", Float64[20; 1.0]))
addBearingRangeFactor(synchronyConfig, robotId, sessionId, newBearingRangeFactor)
newBearingRangeFactor2 = BearingRangeRequest("x7", "l1",
                           DistributionRequest("Normal", Float64[0; 0.1]),
                           DistributionRequest("Normal", Float64[20; 1.0]))
addBearingRangeFactor(synchronyConfig, robotId, sessionId, newBearingRangeFactor2)

# 7. Now let's tell the solver to pick up on all the latest changes.
putReady(synchronyConfig, robotId, sessionId, true)

#TODO: WIP!

# Time to draw some data!

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
