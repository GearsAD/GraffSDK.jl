# Tutorial showing how to visualize graphs using public API
using SynchronySDK

# 1. Import the initialization code.
cd(joinpath(Pkg.dir("SynchronySDK"),"examples"))
include("0_Initialization.jl")

# Create a Configuration
robotId = "PythonBot"
sessionId = "PythonSessionNick"
# synchronyConfig = loadConfig("synchronyConfig_NaviEast_Internal.json")
synchronyConfig = loadConfig("/home/dehann/Documents/synchronyConfig.json")

# 2. Confirm that the robot already exists
println(" - Retrieving robot '$robotId'..."
if !SynchronySDK.isRobotExisting(synchronyConfig, robotId)
    error(" -- Robot '$robotId' doesn't exist...")
end
println(robot)

# 3. Confirm the session exists.
println(" - Retrieving data session '$sessionId' for robot...")
if !SynchronySDK.isSessionExisting(synchronyConfig, robotId, sessionId)
    error(" -- Session '$sessionId' doesn't exist for robot '$robotId'...")
end
println(session)

# Visualize the session
# Using the bigdata key 'TestImage' as the camera image
visualizeSession(synchronyConfig, robotId, sessionId, "TestImage")
