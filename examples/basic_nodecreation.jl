using GraffSDK
# Packages required for factor creation
using RoME
using Distributions

# 1. Import the initialization code.
cd(joinpath(Pkg.dir("GraffSDK"),"examples"))
include("0_Initialization.jl")

# 1a. Create a Configuration
config = loadGraffConfig("synchronyConfig.json")
#Create a hexagonal sessions
config.robotId = "DemoRobot"
config.sessionId = "DemoSession2"
println(getGraffConfig())

# --- Creating the robot if it doesn't exist ---- #
if !isRobotExisting()
    # Create a new one programatically - can also do this via the UI.
    println(" -- Robot '$(config.robotId)' doesn't exist, creating it...")
    newRobot = RobotRequest(config.robotId, "My New Bot", "Description of my neat robot", "Active")
    robot = addRobot(newRobot)
end

# --- Deleting the session if it exists---- #
if isSessionExisting()
    println(" -- Session '$(config.sessionId)' already exists for robot '$(config.robotId)', deleting and recreating it...")
    deleteSession()
end

# --- Make a new session - x0 will automatically be created during this call.

session = nothing
if isSessionExisting()
    println(" -- Session '$(config.sessionId)' already exists for robot '$(config.robotId)', retrieving it...")
    session = getSession()
else
    # Create a new one
    println(" -- Session '$(config.sessionId)' doesn't exist for robot '$(config.robotId)', creating it...")
    newSessionRequest = SessionDetailsRequest(config.sessionId, "A test dataset demonstrating basic graph creation.", "Pose2")
    session = addSession(newSessionRequest)
end

# --- Adding Variables ---- #
x1Request = VariableRequest("x1", "Pose2")
response = addVariable(x1Request)

x2Request = VariableRequest("x2", "Pose2")
response = addVariable(x2Request)

newLandmark = VariableRequest("l1", "Point2", ["LANDMARK"])
response = addVariable(newLandmark)

# --- Adding Factors ---- #

deltaMeasurement = [1.0; 1.0; pi/4]
pOdo = Float64[0.1 0 0; 0 0.1 0; 0 0 0.01]
p2p2 = Pose2Pose2(MvNormal(deltaMeasurement, pOdo.^2))
p2p2Conv = convert(PackedPose2Pose2, p2p2)
p2p2Request = FactorRequest(["x0", "x1"], "Pose2Pose2", p2p2Conv)

# Send the request for the x0->x1 link
addFactor(p2p2Request)
# Update the request to make the same link between x1 and x2
p2p2Request.variables = ["x1", "x2"]
addFactor(p2p2Request)

# Lastly, let's add the bearing+range factor between x1 and landmark l1
bearingDist = Normal(-pi/4, 0.1)
rangeDist = Normal(18, 1.0)
p2br2 = Pose2Point2BearingRange(bearingDist, rangeDist)
p2br2Conv = convert(PackedPose2Point2BearingRange, p2br2)
p2br2Request = FactorRequest(["x1", "l1"], "Pose2Point2BearingRange", p2br2Conv)
addFactor(p2br2Request)
# Now add the x1->l1 bearing+range factor
p2br2Request.variables = ["x2", "l1"]
addFactor(p2br2Request)

# We can now set these to ready and the server will solve it
putReady(true)
