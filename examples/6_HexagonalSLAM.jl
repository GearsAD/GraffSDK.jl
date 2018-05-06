# tutorial on conventional 2D SLAM example
# This tutorial shows how to use some of the commonly used factor types
# This tutorial follows from the ContinuousScalar example from IncrementalInference
using SynchronySDK


# 1. Import the initialization code.
cd(joinpath(Pkg.dir("SynchronySDK"),"examples"))
include("0_Initialization.jl")

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

# 4. Drive around in a hexagon
println(" - Adding hexagonal driving pattern to session...")
for i in 0:5
    deltaMeasurement = [10.0;0;pi/3]
    pOdo = Float64[[0.1 0 0] [0 0.1 0] [0 0 0.1]]
    println(" - Measurement $i: Adding new odometry measurement '$deltaMeasurement'...")
    newOdometryMeasurement = AddOdometryRequest(deltaMeasurement, pOdo)
    @time @show response = addOdometryMeasurement(synchronyConfig, robotId, sessionId, newOdometryMeasurement)
end
# putReady(synchronyConfig, robotId, sessionId, true)

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
# TODO: Allow for putReady to take in a list.
putReady(synchronyConfig, robotId, sessionId, true)


#############################
####### Visualization #######
#############################

# Ref: https://github.com/rdeits/MeshCat.jl/blob/master/demo.ipynb

# NOTE: WIP!
# I'd like the SDK to do this natively...

using MeshCat
using CoordinateTransformations
import GeometryTypes: HyperRectangle, Vec, Point, HomogenousMesh, SignedDistanceField
import ColorTypes: RGBA, RGB

# Create a new visualizer instance
vis = Visualizer()
open(vis)

# Retrieve all variables and render them.
println("Retrieving all variables and rendering them...")
nodes = getNodes(slam_client.syncrconf, robotId, sessionId)
for node in nodes
    println(" - Rendering $node")
    triad = Triad()
    setobject!(vis["Triad $node"], triad)
    settransform!(vis["Triad $node"], Translation(node,node,node))
end
