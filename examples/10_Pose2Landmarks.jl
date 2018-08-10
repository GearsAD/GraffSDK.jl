
using SynchronySDK
using RoME, Distributions
using ProgressMeter

# 1. Import the initialization code.
include(joinpath(Pkg.dir("SynchronySDK"),"examples", "0_Initialization.jl"))

# 1a. Create a Configuration
robotId = "DynamicPoses"
sessionId = "TestDynamicSession003"
# synchronyConfig = loadConfig("synchronyConfig_Local.json")
synchronyConfig = loadConfig(joinpath(ENV["HOME"],"Documents","synchronyConfig.json"))

# 1b. Check the credentials and the service status
printStatus(synchronyConfig)

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
    newSessionRequest = SessionDetailsRequest(sessionId, "A test dataset demonstrating data ingestion for a wheeled vehicle driving in a hexagon.", "")
    session = addSession(synchronyConfig, robotId, newSessionRequest)
end
println(session)


# start building the factor graph
firstPose = VariableRequest("x0", "DynPose2(ut=0)", nothing, ["POSE"])
response = addVariable(synchronyConfig, robotId, sessionId, firstPose)




dp2_fact = DynPose2VelocityPrior(MvNormal(zeros(3),diagm([0.01;0.01;0.001].^2)),
                                 MvNormal(zeros(2),diagm([0.3;0.01].^2)))
# 2. Pack the prior (we can automate this step soon, but for now it's hand cranking)
pd2_packed = convert(RoME.PackedDynPose2VelocityPrior, dp2_fact)

# 3. Build the factor request (again, we can make this way easier and transparent once it's stable)
fctBody = SynchronySDK.FactorBody(string(typeof(dp2_fact)), string(typeof(pd2_packed)), "JSON", JSON.json(pd2_packed))
fctRequest = SynchronySDK.FactorRequest(["x0";], fctBody, false, false)
resp = SynchronySDK.addFactor(synchronyConfig, robotId, sessionId, fctRequest)





# 4. Drive around in a hexagon
imgRequest = DataHelpers.readImageIntoDataRequest("pexels-photo-1004665.jpeg", "TestImage", "Pretty neat public domain image", "image/jpeg");
println(" - Adding hexagonal driving pattern to session...")
@showprogress for i in 1:6
    deltaMeasurement = [10.0;0;pi/3]
    pOdo = Float64[0.1 0 0; 0 0.1 0; 0 0 0.1]
    println(" - Measurement $i: Adding new odometry measurement '$deltaMeasurement'...")
    newOdometryMeasurement = AddOdometryRequest(deltaMeasurement, pOdo)
    @time @show addOdoResponse = addOdometryMeasurement(synchronyConfig, robotId, sessionId, newOdometryMeasurement)
    println("  - Adding image data to the pose...")
    # Adding image data
    addOrUpdateDataElement(synchronyConfig, robotId, sessionId, addOdoResponse.variable, imgRequest)
end


newLandmark = VariableRequest("l1", "Pose2", nothing, ["LANDMARK"])
response = addVariable(synchronyConfig, robotId, sessionId, newLandmark)
newBearingRangeFactor = BearingRangeRequest("x1", "l1",
                          DistributionRequest("Normal", Float64[0; 0.1]),
                          DistributionRequest("Normal", Float64[20; 1.0]))
addBearingRangeFactor(synchronyConfig, robotId, sessionId, newBearingRangeFactor)
