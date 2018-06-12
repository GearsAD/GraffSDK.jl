using Base
using JSON, Unmarshal
using SynchronySDK

robotId = "NewRobotSam"

# 1. Get a Synchrony configuration
# Assume that you're running in local directory
cd(joinpath(Pkg.dir("SynchronySDK"),"examples"))
configFile = open("synchronyConfig_NaviEast_DEV.json")
configData = JSON.parse(readstring(configFile))
close(configFile)
synchronyConfig = Unmarshal.unmarshal(SynchronyConfig, configData)

# 2a. Robot creation and retrieval
# Creating a bot allows us to create session data for that robot.
# and associate it with data sessions
newRobot = RobotRequest(robotId, "My New Bot", "Njord in AWS", "Active")
retRobot = addRobot(synchronyConfig, newRobot)
@show retRobot
# Now we can get it as well if we want
getRobotDetails = getRobot(synchronyConfig, newRobot.id)
if (JSON.json(retRobot) != JSON.json(getRobotDetails))
    error("Hmm, robots should match")
end

# 2b. Get robots
# Just for example's sake - let's retrieve all robots associated with our user
robots = getRobots(synchronyConfig)
@show robots

# 3. Set some user configuration parameters for the robot
robotConfig = getRobotConfig(synchronyConfig, newRobot.id)
testConfiguration = Dict{String, String}("myUserConfigSetting" => "Testing", "MoreSettings" => "Store your robot settings here!")
updatedConfig = updateRobotConfig(synchronyConfig, newRobot.id, testConfiguration)
refreshedConfig = getRobotConfig(synchronyConfig, newRobot.id)
