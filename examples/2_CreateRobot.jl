using Base
using JSON, Unmarshal
using SynchronySDK

# 0. Constants
userId = "NewUser"

# 1. Get a Synchrony configuration
# Assume that you're running in local directory
configFile = open("synchronyConfig_Local.json")
configData = JSON.parse(readstring(configFile))
close(configFile)
synchronyConfig = Unmarshal.unmarshal(SynchronyConfig, configData)

# 2. Authorizing ourselves for requests
authRequest = AuthRequest("user", "apiKey")
auth = authenticate(synchronyConfig, authRequest)

# 3a. Robot creation and retrieval
# Creating a bot allows us to create session data for that robot.
# and associate it with data sessions
newRobot = RobotRequest("NewRobot2", "Test New Robot", "A test robot", "Active")
retRobot = createRobot(synchronyConfig, auth, userId, newRobot)
@show retRobot
# Now we can get it as well if we want
getRobotDetails = getRobot(synchronyConfig, auth, userId, newRobot.id)
if (JSON.json(retRobot) != JSON.json(getRobotDetails))
    error("Hmm, robots should match")
end

# 3b. Get robots
# Just for example's sake - let's retrieve all robots associated with our user
robots = getRobots(synchronyConfig, auth, userId)
@show robots
