# Working with Data

The Synchrony Project is not just for building and solving factor graphs. You can also store and link arbitrary data to nodes in the graph. The graph then becomes a natural index for all sensory (and processed data), so you can  randomly access all sensory information across multiple sessions and multiple robots. Timestamped poses are naturally great indices for searching data in the time-domain, in locations or regions, or across multiple devices. Think shared, collective, successively growing memory :)

We're still working on the best ways to do this, but it's one our key missions: to provide you with a simple way to insert massive amounts of sensory data into the graph and efficiently query+extract it at some point in the future across multiple systems.

If you want to see the start of this at work, take a look at the [Brookstone Rover example](Link!), where we:
* Insert data + video imagery from a LCM log (pretending to be a robot)
* Extract the images in another process and identify AprilTags (pretending to be a Apri processor either on the robot, on a base station, or in the cloud :))
* Insert new loop closures into the graph together with the AprilTag ID's
* Allow the solver to refine the graph given these new bearing+range measurements

## An Overview of Our Data Model

Consider that a single pose can have multiple raw data elements attached to it - a camera image, a lidar scan, an audio snippet. It can also have processed data elements that may be include once that processing is completed.

In our data model, we let you attach named data elements to any node. That means that data looks like a big dictionary, with some additional property information, like this:

* x1
  * Data entries
    * "CamImage": [Dataaaaa]
    * "LidarScan": [Dataaaa]
    * "Audio": [Dataaa]
    * "AprilTagDetections": [More dataaa, probably appearing later]
* x2
* ...

In the following sections, we look at:
* Listing all data entries and metadata in a node
* Extracting and view the data elements
* Attaching, updating, and deleting data elements
* A quick discussion on encoding and decoding using Base64

To start, let's assume we have a valid Synchrony configuration and have a node from a graph:

```julia
using Base
using SynchronySDK

# 1. Get a Synchrony configuration
# Assume that you're running in local directory
synchronyConfig = loadConfigFile("synchronyConfig.json")

robotId = "Hexagonal" # Update these
sessionId = "HexDemo1" # Update these

# Get all nodes and select the first for this example
sessionNodes = getNodes(synchronyConfig, robotId, sessionId);
if length(sessionNodes.nodes) == 0
  error("Please update the robotId and sessionId to give back some existing nodes, or run the hexagonal example to make a new dataset.")
end

# Get the first node - we don't need the complete node, just the summary - no getNode call needed.
node = sessionNodes.nodes[1]

```

## Listing All Data Entries in a Pose or Factor
We can extract all data entries with the `getDataEntries` method:

```julia
dataEntries = getDataEntries(synchronyConfig, robotId, sessionId, node)
@show dataEntries

dataEntry = nothing
if length(dataEntries) > 0
  dataEntry = dataEntries[1]
else
  warn("No data entries returned, you may want to add data before doing the get element call below...")
end
```

In the normal hexagonal example we added an image just for this purpose. You should see a single element listed if you're using that session.

Each data entry response contains the following information:
```julia
mutable struct BigDataEntryResponse
    id::String
    nodeId::Int
    sourceName::String
    description::String
    mimeType::String
    lastSavedTimestamp::String
    links::Dict{String, String}
end
```

Don't worry too much about `sourceName` for now (it really only features in our next release), but the other parameters are important:
* ID is the key of this data element
* Description is a user string, store whatever you want in here
* MIME type gives us a hint for the data type. This is important, because if you tell us it's an image, we can show in the web pages and in the visualization.
  * When you add data, use one of these MIME types [Mime Types](link!)
  * Two often-used types are "application/octet-stream" and "application/json". By default, if you don't specify a type, we internally set it to "application/octet-stream" - that indicates binary data.

## Getting and Viewing Data Elements
Entries are distinct from elements, because we want you to be able to list data quickly (get summary entries), and then choose which data elements you want to retrieve. Each element could be ~100Mb, so our APIs are designed to let you cherry pick what to pull down the wire.

We can now get the element:

```julia
@show dataElem = getDataElement(synchronyConfig, robotId, sessionId, node, dataEntry)
```

This contains the same information as the entry, but there is now a `data` string property with the data in it. Generally we base64 encode this data to make sure it fits into a string datatype, and if you've retrieved the image from the Hexagonal example, it should just look like a bunch of ASCII.

If we want to skip getting all the entry information again, we can just call `getRawDataElement`, which returns a string:

```julia
@show dataElemRaw = getRawDataElement(synchronyConfig, robotId, sessionId, node dataEntry)
```  

In the Hexagonal example, we base64 encoded an image and attached it to every pose, so if you're using that data set, we can visualize this image with the following snippet:

```julia
# Decode the raw image into a Vector{Uint8}
imgBytes = base64decode(dataElemRaw)

# Use the neat Images.jl, ImageView.jl, and ImageMagick.jl to show it
# In case you haven't added them:
Pkg.add("Images")
Pkg.add("ImageView")
using Images, ImageView, ImageMagick

# Now read the binary as an image and show
image = readblob(imgBytes)
imshow(image)
```

If you're wondering about the `base64decode` step, please take a look at the last section in this document.

## Attaching, Updating, and Deleting Data Elements
Now that we've discussed getting data, it's pretty easy covering how to add/update/delete data elements.

### Adding or Updating Data
To add data, just make a `BigDataElementRequest` (or use a helper to make one), and submit it.

#### A Matrix
For example, we can construct a huge(ish) 2D matrix, encode it using JSON or ProtoBufs or JLD etc., and submit it:

```julia
using ProtoBuf
myMat = rand(1000, 1000);
dataBytes = JSON.json(myMat);
enc = base64encode(dataBytes);
# Make a Data request
request = BigDataElementRequest("Matrix_Entry", "", "An example matrix", enc);
# Attach it to the node
addOrUpdateDataElement(synchronyConfig, robotId, sessionId, node, request);
```

Now we can retrieve it to see it again:
```julia
dataElemRaw = getRawDataElement(synchronyConfig, robotId, sessionId, node, "Matrix_Entry")
myMatDeser = JSON.parse(dataElemRaw)
```  

There's also a simple helper method for this if you use `SynchronySDK.DataHelpers`:

```julia
using SynchronySDK.DataHelpers

request = encodeBinaryData("Matrix_Entry", "An example matrix", dataBytes)
# Attach it to the node
@show matrixElement = addOrUpdateDataElement(synchronyConfig, robotId, sessionId, node, request)
```

#### Structures and JSON
We can also encode structures as JSON, and send those (no base64 encoding required, and they display nicely in the UI):

```julia
mutable struct TestStruct
  ints::Vector{Int}
  testString::String
  doubleNum::Float64
end

testStruct = TestStruct(1:10, "A test struct", 3.14159)
enc = JSON.json(testStruct)
request = BigDataElementRequest("Struct_Entry", "", "An example struct", enc)
@show structElement = addOrUpdateDataElement(synchronyConfig, robotId, sessionId, node, request)
```

Now we can retrieve it to see it again:
```julia
@show dataElemRaw = getRawDataElement(synchronyConfig, robotId, sessionId, node, "Struct_Entry")
```  

Actually, we've ended up doing this so much we've made a simple helper method for it as well:

```julia
using SynchronySDK.DataHelpers
request = encodeJsonData("Struct_Entry", "An example struct", testStruct)
structElement = addOrUpdateDataElement(synchronyConfig, robotId, sessionId, node, request)
```

#### Images
Images can be sent as their raw encoded bytes with an image MIME type - they will be then displayable in your browser. We've made a helper to load files, which works well here:

```julia
request = DataHelpers.readFileIntoDataRequest(joinpath(Pkg.dir("SynchronySDK"), "examples", "pexels-photo-1004665.jpeg"), "TestImage", "Pretty neat public domain image", "image/jpeg");
imgElement = addOrUpdateDataElement(synchronyConfig, robotId, sessionId, node, request)
```

As above, let's use the Julia image libraries to show this:

```julia
using Images, ImageView, ImageMagick

# Read it, decode it, and make an image all in one line
image = readblob(base64decode(getRawDataElement(synchronyConfig, robotId, sessionId, node, "TestImage")))
# Show it
imshow(image)
```

### Deleting Data
Deleting data is done by calling `deleteDataElement`. For example, we can delete the matrix and the struct elements we just added:

```julia

# Delete by element reference
@show deleteDataElement(synchronyConfig, robotId, sessionId, node, matrixElement)
# Delete by string key
@show deleteDataElement(synchronyConfig, robotId, sessionId, node, "Struct_Entry")
```

## Discussion on Base64 Encoding and Decoding
A quick important point on encoding - it's not strictly required, but we recommend you base64 encode your data and the decode it when you retrieve it if it may contain special characters. That way, if there are non-ASCII characters, they won't be an issue. A little more data has to travel up and down the wire, but it's more robust overall.

```julia
@show unsafeString = "This is an unsafe string...\n\0"
@show encBytes = base64encode(unsafeString)
@show decBytes = base64decode(enc)
@show unsafeReturned = String(decBytes)
```
