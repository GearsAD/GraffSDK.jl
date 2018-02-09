using Base
using JSON, Unmarshal
using SynchronySDK

# 1. Get a Synchrony configuration
# Assume that you're running in local directory
configFile = open("synchronyConfig.json")
configData = JSON.parse(readstring(configFile))
close(configFile)
synchronyConfig = Unmarshal.unmarshal(SynchronyConfig, configData)

# 2. Authorizing ourselves for requests
authRequest = AuthRequest("user", "apiKey")
auth = authorize(synchronyConfig, authRequest)
