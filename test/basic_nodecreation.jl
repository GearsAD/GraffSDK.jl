using GraffSDK
# Packages required for factor creation
using RoME
using Distributions

include(joinpath(Pkg.dir("GraffSDK"),"examples", "0_Initialization.jl"))
synchronyConfig = loadConfig("synchronyConfig.json")
synchronyConfig.userId = "NewUser"
synchronyConfig.robotId = "DemoRobot"
synchronyConfig.sessionId = "DemoSession"

# --- Creating the robot if it doesn't exist ---- #
if !isRobotExisting(synchronyConfig)
    # Create a new one programatically - can also do this via the UI.
    println(" -- Robot '$(synchronyConfig.robotId)' doesn't exist, creating it...")
    newRobot = RobotRequest(synchronyConfig.robotId, "My New Bot", "Description of my neat robot", "Active")
    robot = addRobot(synchronyConfig, newRobot)
end

# --- Deleting the session if it exists---- #
if isSessionExisting(synchronyConfig)
    println(" -- Session '$(synchronyConfig.sessionId)' already exists for robot '$(synchronyConfig.robotId)', deleting and recreating it...")
    deleteSession(synchronyConfig)
end

# --- Make a new session - x0 will automatically be created during this call.
newSessionRequest = SessionDetailsRequest(synchronyConfig.sessionId, "A test dataset demonstrating basic graph creation.", "Pose2")
session = addSession(synchronyConfig, newSessionRequest)

# --- Adding Variables ---- #
x1Request = VariableRequest("x1", "Pose2")
response = addVariable(synchronyConfig, x1Request)

x2Request = VariableRequest("x2", "Pose2")
response = addVariable(synchronyConfig, x2Request)

newLandmark = VariableRequest("l1", "Point2", ["LANDMARK"])
response = addVariable(synchronyConfig, newLandmark)

# --- Adding Factors ---- #

deltaMeasurement = [1.0; 1.0; pi/4]
pOdo = Float64[0.1 0 0; 0 0.1 0; 0 0 0.01]
p2p2 = Pose2Pose2(MvNormal(deltaMeasurement, pOdo.^2))
p2p2Conv = convert(PackedPose2Pose2, p2p2)
p2p2Request = FactorRequest(["x0", "x1"], "Pose2Pose2", p2p2Conv)

# Send the request for the x0->x1 link
addFactor(synchronyConfig, p2p2Request)
# Update the request to make the same link between x1 and x2
p2p2Request.variables = ["x1", "x2"]
addFactor(synchronyConfig, p2p2Request)

# Lastly, let's add the bearing+range factor between x1 and landmark l1
bearingDist = Normal(-pi/4, 0.1)
rangeDist = Normal(18, 1.0)
p2br2 = Pose2Point2BearingRange(bearingDist, rangeDist)
p2br2Conv = convert(PackedPose2Point2BearingRange, p2br2)
p2br2Request = FactorRequest(["x1", "l1"], "Pose2Point2BearingRange", p2br2Conv)
addFactor(synchronyConfig, p2br2Request)
# Now add the x1->l1 bearing+range factor
p2br2Request.variables = ["x2", "l1"]
addFactor(synchronyConfig, p2br2Request)

#Testing
using Unmarshal
j = JSON.parse(JSON.json(p2p2Conv))

fctPackedType = eval(parse(p2p2Request.body.packedFactorType))
Unmarshal.unmarshal(p2p2Request.body.body)
