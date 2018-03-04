using Base
using JSON, Unmarshal
using SynchronySDK

# 0. Constants
userId = "NewUser"
robotId = "NewRobot"

# 1. Get a Synchrony configuration
# Assume that you're running in local directory
configFile = open("synchronyConfig_Local.json")
configData = JSON.parse(readstring(configFile))
close(configFile)
synchronyConfig = Unmarshal.unmarshal(SynchronyConfig, configData)

# 2. Authorizing ourselves for requests
authRequest = AuthRequest(userId, "apiKey")
auth = authenticate(synchronyConfig, authRequest)

# 3a. Create session
# Creating a session allows us to ingest data and start refining the factor graph.
# We can also mine data across all our robots and our sessions.
newSession = SessionDetailsRequest("TestHexagonalDrive9", "A test dataset demonstrating data ingestion for a wheeled vehicle driving in a hexagon.")
retSession = createSession(synchronyConfig, auth, userId, robotId, newSession)
@show retSession
# Now we can get it as well if we want
getSession = getSession(synchronyConfig, auth, userId, robotId, newSession.id)
if (JSON.json(retSession) != JSON.json(getSession))
    error("Hmm, sessions should match")
end

# 3b. Get all sessions
# Just for example's sake - let's retrieve all sessions associated with out robot
sessions = getSessions(synchronyConfig, auth, userId, robotId)
@show sessions

# Get all nodes for our session
nodes = getNodes(synchronyConfig, auth, userId, robotId, newSession.id)
@show nodes
# Get a specific node
nodeDetails = getNode(synchronyConfig, auth, userId, robotId, newSession.id, nodes.nodes[1].id)
