# Tutorial on conventional 2D SLAM example
# This tutorial shows how to use some of the commonly used factor types
# This tutorial follows from the ContinuousScalar example from IncrementalInference
using GraffSDK
using ProgressMeter
using UUIDs

# 1. Import the initialization code.
cd(joinpath(dirname(pathof(GraffSDK)), "..", "examples"))

# 1a. Create a Configuration
config = loadGraffConfig("synchronyConfig_Local.json")
#Create a hexagonal sessions
config.sessionId = "HexDemoSample1_Train4_"*replace(string(uuid4()), "-" => "")
println(getGraffConfig())

# 1b. Check the credentials and the service status
printStatus()

# 2. Confirm that the robot already exists, create if it doesn't.
println(" - Creating or retrieving robot '$(config.robotId)'...")
robot = nothing
if isRobotExisting()
    println(" -- Robot '$(config.robotId)' already exists, retrieving it...")
    robot = getRobot();
else
    # Create a new one programatically - can also do this via the UI.
    println(" -- Robot '$(config.robotId)' doesn't exist, creating it...")
    newRobot = RobotRequest(config.robotId, "My New Bot", "Description of my neat robot", "Active");
    robot = addRobot(newRobot);
end
println(robot)

# 3. Create or retrieve the session.
# Get sessions, if it already exists, add to it.
println(" - Creating or retrieving data session '$(config.sessionId)' for robot...")
session = nothing
if isSessionExisting()
    println(" -- Session '$(config.sessionId)' already exists for robot '$(config.robotId)', retrieving it...")
    session = getSession()
else
    # Create a new one
    println(" -- Session '$(config.sessionId)' doesn't exist for robot '$(config.robotId)', creating it...")
    newSessionRequest = SessionDetailsRequest(config.sessionId, "A test dataset demonstrating data ingestion for a wheeled vehicle driving in a hexagon.", "Pose2")
    session = addSession(newSessionRequest)
end
println(session)


# 4. Drive around in a hexagon
# imgRequest = DataHelpers.readFileIntoDataRequest("pexels-photo-1004665.jpeg", "TestImage", "Pretty neat public domain image", "image/jpeg");
println(" - Adding hexagonal driving pattern to session...")
@showprogress for i in 1:6
    deltaMeasurement = [10.0;0;pi/3]
    pOdo = Float64[0.1 0 0; 0 0.1 0; 0 0 0.1]
    println(" - Measurement $i: Adding new odometry measurement '$deltaMeasurement'...")
    @time addOdoResponse = addOdometryMeasurement(deltaMeasurement, pOdo)
    println("  - Adding image data to the pose...")
    # Adding image data
    # addOrUpdateDataElement(addOdoResponse.variable, imgRequest)
end

# # 5. Now retrieve the dataset
# println(" - Retrieving all data for session $sessionId...")
@time nodes = getNodes()

# By NeoID
node = getNode( nodes.nodes[1].id)
# By Synchrony label
node = getNode( nodes.nodes[1].label)

# 6. Now lets add a couple landmarks
# Ref: https://github.com/dehann/RoME.jl/blob/master/examples/Slam2dExample.jl#L35
# TODO: FIX tonight here
response = addVariable("l1", "Point2", ["LANDMARK"])
newBearingRangeFactor = BearingRangeRequest("x1", "l1",
                          DistributionRequest("Normal", Float64[0; 0.1]),
                          DistributionRequest("Normal", Float64[20; 1.0]))
addBearingRangeFactor(newBearingRangeFactor)
newBearingRangeFactor2 = BearingRangeRequest("x6", "l1",
                           DistributionRequest("Normal", Float64[0; 0.1]),
                           DistributionRequest("Normal", Float64[20; 1.0]))
addBearingRangeFactor(newBearingRangeFactor2)

# 7. Now let's tell the solver to pick up on all the latest changes.
# TODO: Allow for putReady to take in a list.
putReady(true)

# 8. Let's check on the solver updates.
sessionLatest = getSession()
while session.lastSolvedTimestamp != sessionLatest.lastSolvedTimestamp
    println("Comparing latest session solver timestamp $(sessionLatest.lastSolvedTimestamp) with original $(session.lastSolvedTimestamp) - still the same so sleeping for 2 seconds")
    sleep(2)
    sessionLatest = getSession()
end

# 9. Great, solver has updated it! We can render this.
# Using the bigdata key 'TestImage' as the camera image
visualizeSession("TestImage")
