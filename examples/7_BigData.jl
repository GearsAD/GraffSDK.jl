# Example to show a user can retrieve node summaries from the server using the SynchronySDK

# 1. Import the initialization code
# This will create a synchronyConfig structure.
cd(joinpath(Pkg.dir("SynchronySDK"),"examples"))
include("0_Initialization.jl")

# 2a. Get all node summaries in this session
nodes = getNodes(synchronyConfig, robotId, sessionId)
if length(nodes.nodes) == 0
    error("The current session '$sessionId' doesn't contain any nodes, so this example won't be able to continue. Please run either 6_HexagonalSlam.jl or another example to populate data in this session.")
end
println("We retrieved the nodes summary for this session, containing $(length(nodes.nodes)) nodes.")
println("Node summaries contain minimal information about a node, i.e. only the following information:\r\n$(fieldnames(nodes.nodes[1]))")
println()

# 2b. Retrieving details on the first node
println("Let's focus on the first node, which is named '$(nodes.nodes[1].label)', and retrieve more detail...")
exampleNode = getNode(synchronyConfig, robotId, sessionId, nodes.nodes[1].id)
println("Node details contain more information, namely:\r\n$(fieldnames(exampleNode))")
println("We can expand properties to see what is associated with the graph-portion of the node:")
exampleNode.properties
println("We can also look more into the solver information, which is stored in packed:")
exampleNode.packed
println("Lastly, we can look at more REST-like information, which is found in links:")
exampleNode.links
println()

# 3. Adding and retrieving data from the nodes
println("We can now check if there is any sensory data associated with a node by getting the data link...")
dataEntries = getDataEntries(synchronyConfig, robotId, sessionId, exampleNode.id)
println("There are currently $(length(dataEntries)) data entries associated with this node.")
map(entry -> println(" - $entry"), dataEntries)
println()

println("Let's add or update data to it in a couple ways...")
println(" - A simple JSON encoding example:")
struct TestStruct
    aString::String
    bInt::Int
    cDouble::Float64
    dDict::Dict{String, String}
end
testJsonStruct = TestStruct("A String", 5, 64.41, Dict{String, String}("aTest" => "testing", "bTest" => "Something Else"))
dataJsonRequest = DataHelpers.encodeJsonData("TestJSON", "A test JSON structure", testJsonStruct)
# Now send it
addOrUpdateDataElement(synchronyConfig, robotId, sessionId, exampleNode.id, dataJsonRequest)
println()

println("Done! Now let's retrieve it...")
getElementJson = getDataElement(synchronyConfig, robotId, sessionId, exampleNode.id, dataJsonRequest.id)
println(" - Retrieved data for ID '$(dataJsonRequest.id)': $(JSON.parse(getElementJson.data))")
println(" - Updated timestamp: $(getElementJson.lastSavedTimestamp)")
println()

println("We can also get the raw data directly, MIME type already applied, which is great for web browsers...")
rawData = getRawDataElement(synchronyConfig, robotId, sessionId, exampleNode.id, dataJsonRequest.id)
println(" - Raw data: $rawData")
println()

println("Let's do something more exciting - upload an image against a node...")
cd(joinpath(Pkg.dir("SynchronySDK"),"examples"))
imgRequest = DataHelpers.readImageIntoDataRequest("pexels-photo-1004665.jpeg", "TestImage", "Pretty neat public domain image", "image/jpeg");
addOrUpdateDataElement(synchronyConfig, robotId, sessionId, exampleNode.id, imgRequest)
println()

println("Images are Base64 encoded so that they can be transmitted, and when retrieved using the 'raw' endpoint, they are automatically Base64 decoded. The API calls don't perform automatic decoding though, so you will have to follow these steps:")
getElementImg = getDataElement(synchronyConfig, robotId, sessionId, exampleNode.id, imgRequest.id);
println(" - Retrieved data for ID '$(getElementImg.id)': $(floor(length(getElementImg.data)/1024)) kb")
println(" - Updated timestamp: $(getElementImg.lastSavedTimestamp)")
println()
