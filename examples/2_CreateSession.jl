using Base
using GraffSDK

# 1. Get a Synchrony configuration
# Assume that you're running in local directory
cd(joinpath(Pkg.dir("GraffSDK"),"examples"))
config = loadGraffConfig("synchronyConfig.json")
#Update the config (updates internal config too as it's by reference)
sessionId = "HexagonalDrive13"
config.sessionId = sessionId
println(config)

# 2a. Create session
# Creating a session allows us to ingest data and start refining the factor graph.
# We can also mine data across all our robots and our sessions.
# Using the defaults, we are going to create a session that is of type Pose2 (2D poses) and it auto initialized (it makes first pose and attaches a prior)
newSession = SessionDetailsRequest(sessionId, "A test dataset demonstrating data ingestion for a wheeled vehicle driving in a hexagon.")
if !isSessionExisting(sessionId)
    retSession = addSession(newSession)
    @show retSession
end
# Now we can get it as well if we want
retSession = getSession()

# 2b. Get all sessions
# Just for example's sake - let's retrieve all sessions associated with out robot
sessions = getSessions()
@show sessions

# Get all nodes for our session
nodes = getNodes()
@show nodes
# Get a specific node
nodeDetails = getNode(nodes.nodes[1].id)
