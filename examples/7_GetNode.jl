# Example to show a user can retrieve node summaries from the server using the SynchronySDK
using Base
using JSON, Unmarshal
using SynchronySDK

# 0. Constants
userId = "NewUser"
robotId = "PixieBot"
sessionId = "TestHexagonalDrive10"

# 1. Get a Synchrony configuration
cd(joinpath(Pkg.dir("SynchronySDK"),"examples"))
configFile = open(joinpath(dirname(@__FILE__), "synchronyConfig_Local.json"))
configData = JSON.parse(readstring(configFile))
close(configFile)
synchronyConfig = Unmarshal.unmarshal(SynchronyConfig, configData)

# 2. Authorizing ourselves for requests
authRequest = AuthRequest(userId, "apiKey")
auth = authenticate(synchronyConfig, authRequest)

# 3. Get all node summaries in this session
nodes = getNodes(synchronyConfig, userId, robotId, sessionId)
