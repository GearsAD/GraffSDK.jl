using Base
using JSON, Unmarshal
using GraffSDK

# 0. Constants
robotId = "NewRobot"

# 1. Get a Synchrony configuration
# Assume that you're running in local directory
cd(joinpath(Pkg.dir("GraffSDK"),"examples"))
configFile = open("synchronyConfig.json")
configData = JSON.parse(readstring(configFile))
close(configFile)
synchronyConfig = Unmarshal.unmarshal(SynchronyConfig, configData)

# 2a. Create session
# Creating a session allows us to ingest data and start refining the factor graph.
# We can also mine data across all our robots and our sessions.
newSession = SessionDetailsRequest("HexagonalDrive", "A test dataset demonstrating data ingestion for a wheeled vehicle driving in a hexagon.")
retSession = createSession(synchronyConfig, robotId, newSession)
@show retSession
# Now we can get it as well if we want
getSession = getSession(synchronyConfig, robotId, newSession.id)
if (JSON.json(retSession) != JSON.json(getSession))
    error("Hmm, sessions should match")
end

# 2b. Get all sessions
# Just for example's sake - let's retrieve all sessions associated with out robot
sessions = getSessions(synchronyConfig, robotId)
@show sessions

# Get all nodes for our session
nodes = getNodes(synchronyConfig, robotId, newSession.id)
@show nodes
# Get a specific node
nodeDetails = getNode(synchronyConfig, robotId, newSession.id, nodes.nodes[1].id)
