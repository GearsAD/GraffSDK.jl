# Tutorial on conventional 2D SLAM example
# This tutorial shows how to use some of the commonly used factor types
# This tutorial follows from the ContinuousScalar example from IncrementalInference
using GraffSDK
using GraffSDK.DataHelpers
using ProgressMeter
using UUIDs
using Caesar

# 1a. Create a Configuration
config = loadGraffConfig()
config.sessionId = "HexDemoSample1_"*replace(string(uuid4())[1:6], "-" => "")

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
addVariable(:x0, Pose2)
# Add at a fixed location PriorPose2 to pin :x0 to a starting location (10,10, pi/4)
addFactor([:x0], IIF.Prior( MvNormal([10; 10; pi/6.0], Matrix(Diagonal([0.1;0.1;0.05].^2)) )))

# imgRequest = DataHelpers.readFileIntoDataRequest("pexels-photo-1004665.jpeg", "TestImage", "Pretty neat public domain image", "image/jpeg");
println(" - Adding hexagonal driving pattern to session...")
@showprogress for i in 0:5
    psym = Symbol("x$i")
    nsym = Symbol("x$(i+1)")
    addVariable(nsym, Pose2)

    pp = Pose2Pose2(MvNormal([10.0;0;pi/3], Matrix(Diagonal([0.1;0.1;0.1].^2))))
    addFactor([psym;nsym], pp )
    # println("  - Adding a simple (largish) image data to the pose...")
    # Adding image data
    # setData("x$i", imgRequest)
end

# 5. Now lets add a couple landmarks
# Ref: https://github.com/dehann/RoME.jl/blob/master/examples/Slam2dExample.jl#L35
response = addVariable(:l0, Point2)
p2br2 = Pose2Point2BearingRange(Normal(0,0.1),Normal(20.0,1.0))
addFactor([:x0; :l0], p2br2)
addFactor([:x6; :l0], p2br2)

# Landmarks generally require more work once they're created, e.g. creating factors,
# so they are not set to ready by default. Once you've completed all the factor links and want to solve,
# call putReady to tell the solver it can use the new nodes. This is added to the end of the processing queue.
putReady(true)

# 5. Checking solver status, getting data
# Let's wait for all nodes to be processed
@time while getSessionBacklog() > 0
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

# Now get a list of all the variables in the graph
@time nodes = GraffSDK.ls()

# Get the estimates to see how far along it is (this just retrieves node.properties["MAP_est"])
# but simplifies getting info
getEstimates()
# You can also give it a list, e.g. just the landmarks
getEstimates(nodes=getLandmarks())

# Other things you can do: Get the full node detail with getNode:
# # By NeoID
# node = getNode( nodes.nodes[1].id)
# # By Graff label
# node = getNode( nodes.nodes[1].label)

# Or checking on solver status:
sessionLatest = getSession()
@info "Graff last solved: $(sessionLatest.lastSolvedTimestamp)"
# Manually request a full session solve if you would like to make sure all is good.
requestSessionSolve()
while sessionLatest.lastSolvedTimestamp == getSession().lastSolvedTimestamp
    @info "Waiting on updated full graph solve..."
    sleep(2)
end
@info "Graff last solved: $(getSession().lastSolvedTimestamp)"
