using GraffSDK
using GraffSDK.DataHelpers
using ProgressMeter
using UUIDs
using Caesar

# 1a. Create a Configuration
config = loadGraffConfig()
# config.sessionId = "HexDemoSample1_"*replace(string(uuid4())[1:6], "-" => "")
config.sessionId = "HexDemoSample1_3529fd"

println(getGraffConfig())

# 1b. Check the credentials and the service status
printStatus()
# 1c. Check the session queue length
@info "Session backlog (queue length) = $(getSessionBacklog())"

# Variable data
GraffSDK.ls()
x0 = getVariable(:x0)
x0.packed
x0.type

## Getting all data entries for the whole session.
sessionDataEntries = getSessionDataEntries()

## Getting individual elements
# By variable
dataEntries = getDataEntries(getVariable(:x1))
@info dataEntries
dataEntry = GraffSDK.getData(getVariable("x1"), dataEntries[1])
# This is raw bytestream now, but we can convert it if we know it's JSON.
if dataEntry.mimeType == "application/json"
    @info String(dataEntry.data)
end
dataEntry = GraffSDK.getData(getVariable("x1"), dataEntries[2])
# TODO: Show as PNG

## Making a new element
# Now lets make a new element
newElement = BigDataElementRequest(
    "NewElement"*replace(string(uuid4())[1:6], "-" => ""),
    "Mongo", "A simple description", rand(UInt8, 100), "application/octet-stream")
GraffSDK.setData(getVariable("x1"), newElement)
dataEntries = getDataEntries(getVariable(:x1))
# Now let's get it back...
dataEntry = GraffSDK.getData(getVariable("x1"), newElement.id)

# Kablam!!! :D
