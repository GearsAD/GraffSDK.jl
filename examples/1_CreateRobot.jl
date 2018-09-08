using Base
using GraffSDK

# 1. Get a Synchrony configuration
# Assume that you're running in local directory
cd(joinpath(Pkg.dir("GraffSDK"),"examples"))
config = loadGraffConfig("synchronyConfig.json")
#Update the config (updates internal config too as it's by reference)
robotId = "NewRobotSam4"
config.robotId = "NewRobotSam4"

# 2a. Robot creation and retrieval
# Creating a bot allows us to create session data for that robot.
# and associate it with data sessions
if !isRobotExisting(robotId)
    newRobot = RobotRequest(robotId, "My New Bot", "Cloudy Robot", "Active")
    retRobot = addRobot(newRobot)
end

# Now we can get it as well if we want, just asking for our default robot set in the config
getRobotDetails = getRobot()

# 2b. Get robots
# Just for example's sake - let's retrieve all robots associated with our user
robots = getRobots()
@show robots

# 3. Set some user configuration parameters for the robot
robotConfig = getRobotConfig()
testConfiguration = Dict{String, String}("myUserConfigSetting" => "Testing", "MoreSettings" => "Store your robot settings here!")
updatedConfig = updateRobotConfig(testConfiguration)
refreshedConfig = getRobotConfig()
