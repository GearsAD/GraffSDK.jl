# Tutorial on conventional 2D SLAM example
# This tutorial shows how to use some of the commonly used factor types
# This tutorial follows from the ContinuousScalar example from IncrementalInference
using GraffSDK
using ProgressMeter
import Dates
import GraffSDK.DataHelpers

beginSleep = rand(15:60)
println(" - Sleeping for $(beginSleep) seconds - ")
sleep(beginSleep)

# Load config
config = loadGraffConfig("config.json")

# Create a session that is unique
config.sessionId = string("DDOSHex",Dates.value(Dates.now()))

# 2. Confirm that the robot already exists, create if it doesn't.
println(" - Creating or retrieving robot '$(config.robotId)'...")
robot = nothing
if isRobotExisting()
    println(" -- Robot '$(config.robotId)' already exists, retrieving it...")
    robot = getRobot()
else
    # Create a new one programatically - can also do this via the UI.
    println(" -- Robot '$(config.robotId)' doesn't exist, creating it...")
    newRobot = RobotRequest(config.robotId, "My New Bot", "Description of my neat robot", "Active")
    robot = addRobot(newRobot)
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
    newSessionRequest = SessionDetailsRequest(config.sessionId, "Virtual wheeled robot driving in hexagon. One of many!", "Pose2")
    session = addSession(newSessionRequest)
end
println(session)

cycles = rand(1:10)

for cycle = 1:cycles
    println(" - Running cycle $(cycle) of $(cycles) - ")
    # 4. Drive around in a hexagon
    imgRequest = DataHelpers.readFileIntoDataRequest("pexels-photo-1004665.jpeg", "TestImage", "Pretty neat public domain image", "image/jpeg");
    println(" - Adding hexagonal driving pattern to session...")
    @showprogress for i in 1:6
        deltaMeasurement = [10.0;0;pi/3]
        pOdo = Float64[0.1 0 0; 0 0.1 0; 0 0 0.1]
        println(" - Measurement $i: Adding new odometry measurement '$deltaMeasurement'...")
        newOdometryMeasurement = AddOdometryRequest(deltaMeasurement, pOdo)
        @time @show addOdoResponse = addOdometryMeasurement(newOdometryMeasurement)
        println("  - Adding image data to the pose...")
        # Adding image data
        addOrUpdateDataElement(addOdoResponse.variable, imgRequest)
    end

    # # 5. Now retrieve the dataset
    # println(" - Retrieving all data for session $sessionId...")
    @time nodes = getNodes();

    # By NeoID
    node = getNode( nodes.nodes[1].id);
    # By Synchrony label
    node = getNode( nodes.nodes[1].label);

    # 7. Now let's tell the solver to pick up on all the latest changes.
    # TODO: Allow for putReady to take in a list.
    putReady(true)

end

endSleep = rand(15:60)
println(" - Sleeping for $(endSleep) seconds - ")
sleep(endSleep)
