# Tutorial on conventional 2D SLAM example
# This tutorial shows how to use some of the commonly used factor types
# This tutorial follows from the ContinuousScalar example from IncrementalInference
using GraffSDK
using GraffSDK.DataHelpers
using ProgressMeter
using UUIDs

# 1. Import the initialization code.
cd(joinpath(dirname(pathof(GraffSDK)), "..", "examples"))

# 1a. Create a Configuration
config = loadGraffConfig("graffConfigVirginia.json");
# config = loadGraffConfig("synchronyConfigLocal.json");
#Create a hexagonal sessions
# config.sessionId = "HexDemoSample1_aa610bdd89be42168973088a1c1b8f33"
config.sessionId = "HexDemoSample1_"*replace(string(uuid4()), "-" => "")
println(getGraffConfig())

# 1b. Check the credentials and the service status
printStatus()
# 1c. Check the session queue length
@info "Session backlog (queue length) = $(getSessionBacklog())"

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
imgRequest = DataHelpers.readFileIntoDataRequest("pexels-photo-1004665.jpeg", "TestImage", "Pretty neat public domain image", "image/jpeg");
println(" - Adding hexagonal driving pattern to session...")
@showprogress for i in 1:6
    deltaMeasurement = [10.0;0;pi/3]
    pOdo = Float64[0.1 0 0; 0 0.1 0; 0 0 0.1]
    println(" - Measurement $i: Adding new odometry measurement '$deltaMeasurement'...")
    @time addOdometryMeasurement(deltaMeasurement, pOdo)
    println("  - Adding image data to the pose...")
    # Adding image data
    setData("x$i", imgRequest)
end

# 5. Now lets add a couple landmarks
# Ref: https://github.com/dehann/RoME.jl/blob/master/examples/Slam2dExample.jl#L35
response = addVariable("l1", "Point2", ["LANDMARK"])
newBearingRangeFactor = BearingRangeRequest("x0", "l1",
                          DistributionRequest("Normal", Float64[0; 0.1]),
                          DistributionRequest("Normal", Float64[20; 1.0]))
addBearingRangeFactor(newBearingRangeFactor)
newBearingRangeFactor2 = BearingRangeRequest("x6", "l1",
                           DistributionRequest("Normal", Float64[0; 0.1]),
                           DistributionRequest("Normal", Float64[20; 1.0]))
addBearingRangeFactor(newBearingRangeFactor2)

# # 5. Now retrieve the dataset
# Let's wait for all nodes to be processed
while getSessionBacklog() > 0
    @info "...Session backlog currently has $(getSessionBacklog()) entries, waiting until complete..."
    sleep(2)
end
@info "Okay processing the last node! ...Yeah so we're going to focus on making that faster in the next release (please go write an issue in GraffSDK to spur us along!)"

# Lets see that everything processed successfully
@info "Session dead queue length = $(getSessionDeadQueueLength())"
if getSessionDeadQueueLength() > 0
    @error "This shouldn't happen, please examine the failed messages below to see what went wrong:"
    deadMsgs = getSessionDeadQueueMessages()
    map(d -> println(d["error"]), deadMsgs)
else
    @info "No messages in the dead queue (errors) on the server, looks good!"
end
# You can ask to reprocess them, or delete them with these commands:
# reprocessDeadQueueMessages()
# deleteDeadQueueMessages()

@time nodes = GraffSDK.ls()

# # By NeoID
# node = getNode( nodes.nodes[1].id)
# # By Graff label
# node = getNode( nodes.nodes[1].label)

# 7. Now let's tell the solver to pick up on all the latest changes.
# TODO: Allow for putReady to take in a list.
putReady(true)
# Manually request session solve if you would like to make sure all is good.
requestSessionSolve()

# 8. Let's check on the solver updates.
session = getSession()
sessionLatest = getSession()
# Lets request a manual, complete session solve - shouldn't be necessary but we want to demonstrate that we can.
while session.lastSolvedTimestamp != sessionLatest.lastSolvedTimestamp
    println("Comparing latest session solver timestamp $(sessionLatest.lastSolvedTimestamp) with original $(session.lastSolvedTimestamp) - still the same so sleeping for 2 seconds")
    sleep(2)
    sessionLatest = getSession()
end

# Visualization is now done with Arena
# TODO: Provide arena example.
# # 9. Great, solver has updated it! We can render this.
# # Using the bigdata key 'TestImage' as the camera image
# visualizeSession("TestImage")
