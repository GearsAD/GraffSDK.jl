var documenterSearchIndex = {"docs": [

{
    "location": "index.html#",
    "page": "Home",
    "title": "Home",
    "category": "page",
    "text": "(Image: GraffSDK.jl Logo)"
},

{
    "location": "index.html#GraffSDK.jl-Documentation-1",
    "page": "Home",
    "title": "GraffSDK.jl Documentation",
    "category": "section",
    "text": "This package is an SDK for SlamInDb/Graff."
},

{
    "location": "index.html#Installation-1",
    "page": "Home",
    "title": "Installation",
    "category": "section",
    "text": "This package is not yet registered with JuliaLang/METADATA.jl, but can be easily installed in Julia 0.6 with:Pkg.clone(\"https://github.com/GearsAD/GraffSDK.jl.git\")\nPkg.build(\"GraffSDK\")"
},

{
    "location": "index.html#Manual-Outline-1",
    "page": "Home",
    "title": "Manual Outline",
    "category": "section",
    "text": "Pages = [\n    \"index.md\"\n    \"getting_started.md\"\n    \"working_with_data.md\"\n    \"ref_user.md\"\n    \"ref_robot.md\"\n    \"ref_session.md\"\n    \"reference.md\"\n]"
},

{
    "location": "getting_started.html#",
    "page": "Introduction",
    "title": "Introduction",
    "category": "page",
    "text": ""
},

{
    "location": "getting_started.html#Getting-Started-with-Graff-SDK-1",
    "page": "Introduction",
    "title": "Getting Started with Graff SDK",
    "category": "section",
    "text": "This documents the steps for using the SDK, as shown in the examples folder.This example will walk through the following steps, demonstrating how you can manage, ingest, and extract data for your robots:Loading a Synchrony configuration\nGetting your user information and runtime configuration\nCreating a robot that will produce data and ingest it into Synchrony\nCreating a new robot session\nImporting data into the new session\nRunning the solver to refine the graph\nViewing the results of the SLAM solutionThe first step is to create a new script file and import the base libraries:using Base\nusing GraffSDK"
},

{
    "location": "getting_started.html#Loading-a-Synchrony-Configuration-1",
    "page": "Introduction",
    "title": "Loading a Synchrony Configuration",
    "category": "section",
    "text": "In the same location as the new script, create a file called \'synchronyConfig.json\', and paste in your Synchrony endpoint which was provided when you created your account:{\n  \"apiEndpoint\":\"http://myserver...\",\n  \"apiPort\":8000\n}It is assumed that Julia was started in the same folder as the script, so add the following code to the script to load the configuration:# 1. Get a Synchrony configuration\n# Assume that you\'re running in local directory\nconfigFile = open(\"synchronyConfig.json\")\nconfigData = JSON.parse(readstring(configFile))\nclose(configFile)\nsynchronyConfig = Unmarshal.unmarshal(SynchronyConfig, configData)"
},

{
    "location": "getting_started.html#Creating-a-Token-1",
    "page": "Introduction",
    "title": "Creating a Token",
    "category": "section",
    "text": "Next step is to create a token for your user. Add the following code with your user and API key:# 2. Authorizing ourselves for requests\nauthRequest = AuthRequest(\"user\", \"apiKey\")\nauth = authenticate(synchronyConfig, authRequest)This will fire off an authentication request, and return an AuthRespose that contains a token."
},

{
    "location": "getting_started.html#Getting-your-User-and-Runtime-Configuration-Information-1",
    "page": "Introduction",
    "title": "Getting your User and Runtime Configuration Information",
    "category": "section",
    "text": "Users maintain the runtime configuration, which is the connection information to ingest data as well as receive notifications when the graph is updated.Just to confirm our user information, we do the following:userId = \"myUserId\" #TODO: Replace with your user ID\nuser = getUser(synchronyConfig, auth, myUserId)The \'user\' variable should contain all our account information. This isn\'t a necessary step, but helps us check a new user account to make sure all is correct.We do need to get the runtime information to subscribe to notifications and ingest data though, so let\'s retrieve the runtime configuration for this user:# 3. Config retrieval\n# This contains all the parameters required to ingest or retrieve\n# data from the system.\nruntimeConfig = getUserConfig(synchronyConfig, auth, userId)We can now use the runtime configuration to ingest data for a given robot as well as subscribe for graph updates. Firstly though, we need to create robot and a new session for the data."
},

{
    "location": "getting_started.html#Creating-a-Robot-1",
    "page": "Introduction",
    "title": "Creating a Robot",
    "category": "section",
    "text": "Users manage robots, and in this example we have assumed that your user currently has no robots assigned to them. Let\'s create a robot!TODO"
},

{
    "location": "getting_started.html#Creating-a-New-Session-1",
    "page": "Introduction",
    "title": "Creating a New Session",
    "category": "section",
    "text": ""
},

{
    "location": "getting_started.html#Importing-Data-into-the-New-Session-1",
    "page": "Introduction",
    "title": "Importing Data into the New Session",
    "category": "section",
    "text": "TODO"
},

{
    "location": "handling_errors.html#",
    "page": "Making Robust Calls",
    "title": "Making Robust Calls",
    "category": "page",
    "text": ""
},

{
    "location": "handling_errors.html#Handling-Errors-in-Synchrony-SDK-1",
    "page": "Making Robust Calls",
    "title": "Handling Errors in Synchrony SDK",
    "category": "section",
    "text": "All SDK calls should return success or an exception. We\'ve also added a service status endpoint that you can use to check whether it\'s an error in your code, or the service is experiencing issues.To test the service, you can call getStatus or printStatus:# Get the service status - should respond with \'UP!\'\n@show serviceStatus = getStatus(synchronyConfig)\n\n# Print the service status.\nprintStatus(sychronyConfig)We recommend catching the exceptions in service calls. That way, you can either bubble the exception further, or mask an error. The recommended approach for a robust SDK call is:try\n    robot = getRobot(synchronyConfig, \"IDONTEXIST\")\ncatch ex\n    println(\"Unable to get robot, error is:\");\n    showerror(STDERR, ex, catch_backtrace())\nendIf you want to go further and use the return code to determine what to do (depending on whether it is a 401/403 authorization error or a 500 internal service error), you can use the exception status:try\n    robot = getRobot(synchronyConfig, \"IDONTEXIST\")\ncatch ex\n    println(\"Unable to get robot, error is:\");\n    showerror(STDERR, ex, catch_backtrace())\n    println()\n    if ex.status == 500\n        warn(\"It\'s an internal service error, please confirm that \'IDONTEXIST\' exists :)\")\n    elseif ex.status == 401 || ex.status == 403\n        warn(\"It\'s an authorization error, please check your credentials\")\n    end\nend"
},

{
    "location": "ref_common.html#",
    "page": "Common Structures and Functions",
    "title": "Common Structures and Functions",
    "category": "page",
    "text": ""
},

{
    "location": "ref_common.html#Common-Structures-and-Functions-1",
    "page": "Common Structures and Functions",
    "title": "Common Structures and Functions",
    "category": "section",
    "text": "The following are common structures and functions that are used across all the services."
},

{
    "location": "ref_common.html#GraffSDK.SynchronyConfig",
    "page": "Common Structures and Functions",
    "title": "GraffSDK.SynchronyConfig",
    "category": "type",
    "text": "Configuration structure for Synchrony, it defines the Synchrony Web API endpoint and port.\n\n\n\n"
},

{
    "location": "ref_common.html#GraffSDK.ErrorResponse",
    "page": "Common Structures and Functions",
    "title": "GraffSDK.ErrorResponse",
    "category": "type",
    "text": "Standardized error response for any request. This is returned if any requests fail server-side.\n\n\n\n"
},

{
    "location": "ref_common.html#Structures-1",
    "page": "Common Structures and Functions",
    "title": "Structures",
    "category": "section",
    "text": "SynchronyConfig\nErrorResponse"
},

{
    "location": "ref_common.html#GraffSDK.loadConfigFile",
    "page": "Common Structures and Functions",
    "title": "GraffSDK.loadConfigFile",
    "category": "function",
    "text": "loadConfigFile(filename)\n\n\nLoad a config file from a file name.\n\n\n\n"
},

{
    "location": "ref_common.html#GraffSDK.getStatus",
    "page": "Common Structures and Functions",
    "title": "GraffSDK.getStatus",
    "category": "function",
    "text": "getStatus(config)\n\n\nGet the status of the Synchrony service.\n\n\n\n"
},

{
    "location": "ref_common.html#GraffSDK.printStatus",
    "page": "Common Structures and Functions",
    "title": "GraffSDK.printStatus",
    "category": "function",
    "text": "printStatus(config)\n\n\nPrint the current service status.\n\n\n\n"
},

{
    "location": "ref_common.html#Functions-1",
    "page": "Common Structures and Functions",
    "title": "Functions",
    "category": "section",
    "text": "loadConfigFile\ngetStatus\nprintStatus"
},

{
    "location": "working_with_data.html#",
    "page": "Working with Data",
    "title": "Working with Data",
    "category": "page",
    "text": ""
},

{
    "location": "working_with_data.html#Working-with-Data-1",
    "page": "Working with Data",
    "title": "Working with Data",
    "category": "section",
    "text": "The Synchrony Project is not just for building and solving factor graphs. You can also store and link arbitrary data to nodes in the graph. The graph then becomes a natural index for all sensory (and processed data), so you can  randomly access all sensory information across multiple sessions and multiple robots. Timestamped poses are naturally great indices for searching data in the time-domain, in locations or regions, or across multiple devices. Think shared, collective, successively growing memory :)We\'re still working on the best ways to do this, but it\'s one our key missions: to provide you with a simple way to insert massive amounts of sensory data into the graph and efficiently query+extract it at some point in the future across multiple systems.If you want to see the start of this at work, take a look at the Brookstone Rover example, where we:Insert data + video imagery from a LCM log (pretending to be a robot)\nExtract the images in another process and identify AprilTags (pretending to be a Apri processor either on the robot, on a base station, or in the cloud :))\nInsert new loop closures into the graph together with the AprilTag ID\'s\nAllow the solver to refine the graph given these new bearing+range measurements"
},

{
    "location": "working_with_data.html#Important-Notes-1",
    "page": "Working with Data",
    "title": "Important Notes",
    "category": "section",
    "text": "A few important notes before we continue:Data keys can\'t contain spaces yet, this is a known bug and we\'re chasing up on it.\nAnything with an image MIME type is automatically base64 decoded when a raw data call is made - this is so it can be shown in a browser with no decoding. We\'re looking at a better way to do this, more to follow."
},

{
    "location": "working_with_data.html#An-Overview-of-Our-Data-Model-1",
    "page": "Working with Data",
    "title": "An Overview of Our Data Model",
    "category": "section",
    "text": "Consider that a single pose can have multiple raw data elements attached to it - a camera image, a lidar scan, an audio snippet. It can also have processed data elements that may be include once that processing is completed.In our data model, we let you attach named data elements to any node. That means that data looks like a big dictionary, with some additional property information, like this:x1\nData entries\n\"CamImage\": [Dataaaaa]\n\"LidarScan\": [Dataaaa]\n\"Audio\": [Dataaa]\n\"AprilTagDetections\": [More dataaa, probably appearing later]\nx2\n...In the following sections, we look at:Listing all data entries and metadata in a node\nExtracting and view the data elements\nAttaching, updating, and deleting data elements\nA quick discussion on encoding and decoding using Base64To start, let\'s assume we have a valid Synchrony configuration and have a node from a graph:using Base\nusing SynchronySDK\n\n# 1. Get a Synchrony configuration\n# Assume that you\'re running in local directory\nsynchronyConfig = loadConfigFile(\"synchronyConfig.json\")\n\nrobotId = \"Hexagonal\" # Update these\nsessionId = \"HexDemo1\" # Update these\n\n# Get all nodes and select the first for this example\nsessionNodes = getNodes(synchronyConfig, robotId, sessionId);\nif length(sessionNodes.nodes) == 0\n  error(\"Please update the robotId and sessionId to give back some existing nodes, or run the hexagonal example to make a new dataset.\")\nend\n\n# Get the first node - we don\'t need the complete node, just the summary, so no getNode call needed.\nnode = sessionNodes.nodes[1]"
},

{
    "location": "working_with_data.html#Listing-All-Data-Entries-in-a-Pose-or-Factor-1",
    "page": "Working with Data",
    "title": "Listing All Data Entries in a Pose or Factor",
    "category": "section",
    "text": "We can extract all data entries with the getDataEntries method:dataEntries = getDataEntries(synchronyConfig, robotId, sessionId, node)\n@show dataEntries\n\ndataEntry = nothing\nif length(dataEntries) > 0\n  dataEntry = dataEntries[1]\nelse\n  warn(\"No data entries returned, you may want to add data before doing the get element call below...\")\nendIn the normal hexagonal example we added an image just for this purpose. You should see a single element listed if you\'re using that session.Each data entry response contains the following information:mutable struct BigDataEntryResponse\n    id::String\n    nodeId::Int\n    sourceName::String\n    description::String\n    mimeType::String\n    lastSavedTimestamp::String\n    links::Dict{String, String}\nendDon\'t worry too much about sourceName for now (it really only features in our next release), but the other parameters are important:ID is the key of this data element\nDescription is a user string, store whatever you want in here\nMIME type gives us a hint for the data type. This is important, because if you tell us it\'s an image, we can show in the web pages and in the visualization.\nWhen you add data, use one of these MIME types Mime Types\nTwo often-used types are \"application/octet-stream\" and \"application/json\". By default, if you don\'t specify a type, we internally set it to \"application/octet-stream\" - that indicates binary data."
},

{
    "location": "working_with_data.html#Getting-and-Viewing-Data-Elements-1",
    "page": "Working with Data",
    "title": "Getting and Viewing Data Elements",
    "category": "section",
    "text": "Entries are distinct from elements, because we want you to be able to list data quickly (get summary entries), and then choose which data elements you want to retrieve. Each element could be ~100Mb, so our APIs are designed to let you cherry pick what to pull down the wire.We can now get the element:@show dataElem = getDataElement(synchronyConfig, robotId, sessionId, node, dataEntry)This contains the same information as the entry, but there is now a data string property with the data in it. Generally we base64 encode this data to make sure it fits into a string datatype, and if you\'ve retrieved the image from the Hexagonal example, it should just look like a bunch of ASCII.If we want to skip getting all the entry information again, we can just call getRawDataElement, which returns a string:@show dataElemRaw = getRawDataElement(synchronyConfig, robotId, sessionId, node dataEntry)In the Hexagonal example, we base64 encoded an image and attached it to every pose. Note that at the moment if a big data element has an image MIME type, it\'s automatically base64 decoded whenever gerRawDataElement is called. If you\'re using that data set, we can visualize this image with the following snippet:imgBytes = dataElemRaw\n\n# Use the neat Images.jl, ImageView.jl, and ImageMagick.jl to show it\n# In case you haven\'t added them:\nPkg.add(\"Images\")\nPkg.add(\"ImageView\")\nusing Images, ImageView, ImageMagick\n\n# Now read the binary as an image and show\nimage = readblob(imgBytes)\nimshow(image)If you\'re wondering about the base64decode step, please take a look at the last section in this document."
},

{
    "location": "working_with_data.html#Attaching,-Updating,-and-Deleting-Data-Elements-1",
    "page": "Working with Data",
    "title": "Attaching, Updating, and Deleting Data Elements",
    "category": "section",
    "text": "Now that we\'ve discussed getting data, it\'s pretty easy covering how to add/update/delete data elements."
},

{
    "location": "working_with_data.html#Adding-or-Updating-Data-1",
    "page": "Working with Data",
    "title": "Adding or Updating Data",
    "category": "section",
    "text": "To add data, just make a BigDataElementRequest (or use a helper to make one), and submit it."
},

{
    "location": "working_with_data.html#Structures-and-JSON-1",
    "page": "Working with Data",
    "title": "Structures and JSON",
    "category": "section",
    "text": "We can encode structures as JSON, and send those (it\'s JSON - no base64 encoding required and they display nicely in the UI):mutable struct TestStruct\n  ints::Vector{Int}\n  testString::String\n  doubleNum::Float64\nend\n\ntestStruct = TestStruct(1:10, \"A test struct\", 3.14159)\nenc = JSON.json(testStruct)\nrequest = BigDataElementRequest(\"Struct_Entry\", \"\", \"An example struct\", enc)\n@show structElement = addOrUpdateDataElement(synchronyConfig, robotId, sessionId, node, request)Now we can retrieve it to see it again:@show dataElemRaw = getRawDataElement(synchronyConfig, robotId, sessionId, node, \"Struct_Entry\")Actually, we\'ve ended up doing this so much we\'ve made a simple helper method for it as well:using SynchronySDK.DataHelpers\nrequest = encodeJsonData(\"Struct_Entry\", \"An example struct\", testStruct)\nstructElement = addOrUpdateDataElement(synchronyConfig, robotId, sessionId, node, request)"
},

{
    "location": "working_with_data.html#A-Matrix-1",
    "page": "Working with Data",
    "title": "A Matrix",
    "category": "section",
    "text": "Similarly, we can construct a huge(ish) 2D matrix, encode it using JSON or ProtoBufs or JLD etc., and submit it. As above, let\'s encode it as JSON:myMat = rand(100, 100);\ndataBytes = JSON.json(myMat);\n# Make a Data request\nrequest = BigDataElementRequest(\"Matrix_Entry\", \"\", \"An example matrix\", dataBytes, \"application/json\");\n# Attach it to the node\naddOrUpdateDataElement(synchronyConfig, robotId, sessionId, node, request);Now we can retrieve it to see it again:dataElemRaw = getRawDataElement(synchronyConfig, robotId, sessionId, node, \"Matrix_Entry\");\nmyMatDeser = JSON.parse(dataElemRaw);\n# JSON matrices as deserialized as Put it back into a 2D matrix #TODO - There\'s probably an easier way to do this.\nels = myMatDeser[1];\nfor i in 2:length(myMatDeser)\n  append!(els, myMatDeser[i])\nend\nmyMatDeser = reshape(els, (100,100));\nmyMatDeserIf we want to save it in a more compact, Julia-specific format, here is how we can use JLD (a Julia-specific HFDS format) and save it more compactly:#TODO...Either way, if you want to save it quickly using Base64 binary encoding, there\'s a simple helper method for this in SynchronySDK.DataHelpers:using SynchronySDK.DataHelpers\n\nrequest = encodeBinaryData(\"Matrix_Entry\", \"An example matrix\", dataBytes)\n# Attach it to the node\n@show matrixElement = addOrUpdateDataElement(synchronyConfig, robotId, sessionId, node, request)"
},

{
    "location": "working_with_data.html#Images-1",
    "page": "Working with Data",
    "title": "Images",
    "category": "section",
    "text": "Images can be sent as their raw encoded bytes with an image MIME type - they will be then displayable in your browser. We\'ve made a helper to load files, which works well here:request = DataHelpers.readFileIntoDataRequest(joinpath(Pkg.dir(\"SynchronySDK\"), \"examples\", \"pexels-photo-1004665.jpeg\"), \"TestImage\", \"Pretty neat public domain image\", \"image/jpeg\");\nimgElement = addOrUpdateDataElement(synchronyConfig, robotId, sessionId, node, request)As above, blobs with the image/* datatypes are automatically base64 decoded before they are returned when using the getRawDataElement method. Let\'s retrieve it and use the Julia image libraries to show this:using Images, ImageView, ImageMagick\n\n# Read it, decode it, and make an image all in one line\n# NOTE: Normally we have to do base64 decoding, but images are automatically decoded so that they can be shown in browser.\nimage = readblob(getRawDataElement(synchronyConfig, robotId, sessionId, node, \"TestImage\"));\n# Show it\nimshow(image)"
},

{
    "location": "working_with_data.html#Deleting-Data-1",
    "page": "Working with Data",
    "title": "Deleting Data",
    "category": "section",
    "text": "Deleting data is done by calling deleteDataElement. For example, we can delete the matrix and the struct elements we just added:\n# Delete by element reference\n@show deleteDataElement(synchronyConfig, robotId, sessionId, node, matrixElement)\n# Delete by string key\n@show deleteDataElement(synchronyConfig, robotId, sessionId, node, \"Struct_Entry\")"
},

{
    "location": "working_with_data.html#Discussion-on-Base64-Encoding-and-Decoding-1",
    "page": "Working with Data",
    "title": "Discussion on Base64 Encoding and Decoding",
    "category": "section",
    "text": "A quick important point on encoding - it\'s not strictly required, but we recommend you base64 encode your data and the decode it when you retrieve it if it may contain special characters. That way, if there are non-ASCII characters, they won\'t be an issue. A little more data has to travel up and down the wire, but it\'s more robust overall.@show unsafeString = \"This is an unsafe string...\\n\\0\"\n@show encBytes = base64encode(unsafeString)\n@show decBytes = base64decode(enc)\n@show unsafeReturned = String(decBytes)"
},

{
    "location": "examples/examples.html#",
    "page": "Introduction",
    "title": "Introduction",
    "category": "page",
    "text": ""
},

{
    "location": "examples/examples.html#Examples-1",
    "page": "Introduction",
    "title": "Examples",
    "category": "section",
    "text": ""
},

{
    "location": "examples/examples.html#Conceptual-Examples-1",
    "page": "Introduction",
    "title": "Conceptual Examples",
    "category": "section",
    "text": "There are a few simple examples that take you through the creation of a robot, a session, and add data. These are:Graff Initialization\nCreating a Robot and Adding Configuration Data\nCreating Sessions, Adding Simple Odometry Measurements\nA Deep Dive into Variables and Factors"
},

{
    "location": "examples/examples.html#End-To-End-Examples-1",
    "page": "Introduction",
    "title": "End-To-End Examples",
    "category": "section",
    "text": "We are growing a library of end-to-end examples that highlight specific features of SlamInDb/Graff which we think are, well, cool. These are:The Hexagonal Robot Example: Imagine a little wheeled robot driving in a circle. The tread measurement is a little sketchy, so as it progresses it gets a little less certain of where it is. But, each time it loops around, it\'s fairly certain it sees the same AprilTag. We construct this problem in SlamInDb/Graff, and show how the little guy is able to keep his cool as he progresses on his Sisyphean journey. Concepts highlighted:  \nAdding incremental odometry data\nAdding data to poses\nAdding factors like loop closures\nSolver robustness when contradictory data is provided\nVisualization\nBrookstone Rover Example: In the Brookstone Rover example we implement a real-world version of the Hexagonal example, and demonstrate batch-processing in Graff using a simple $100 robot. The robot is cheap, the data is messy, and we still a good solution. Concepts highlighted:\nIntegrating Graff with MIT\'s LCM to process an LCM log\nProcessing offline camera data\nVisualization"
},

{
    "location": "examples/basics_initialization.html#",
    "page": "Basic Initialization",
    "title": "Basic Initialization",
    "category": "page",
    "text": "Complete code example can be found at Graff Initialization"
},

{
    "location": "examples/basics_robot.html#",
    "page": "Basic Robot",
    "title": "Basic Robot",
    "category": "page",
    "text": "Complete code example can be found at Creating a Robot and Adding Configuration Data"
},

{
    "location": "examples/basics_session.html#",
    "page": "Basic Session",
    "title": "Basic Session",
    "category": "page",
    "text": "Complete code example can be found at Creating Sessions, Adding Nodes"
},

{
    "location": "examples/basics_variablesandfactors.html#",
    "page": "Building Graphs",
    "title": "Building Graphs",
    "category": "page",
    "text": ""
},

{
    "location": "examples/basics_variablesandfactors.html#Adding-Variables-and-Factors-(Building-Graphs)-1",
    "page": "Building Graphs",
    "title": "Adding Variables and Factors (Building Graphs)",
    "category": "section",
    "text": "Irrespective of your application - real-time robotics, batch processing of survey data, or really complex multi-hypothesis modeling - you\'re going to need to need to add factors and variables to a graph. This section discusses how to do that with SlamInDb/Graff:For the frequently-occurring cases, like streaming robotics, we have added convenience methods. We will also continue to do so for other scenarios, hopefully incrementally building easier/cleaner libraries and expertise for the wide variety of solutions that SlamInDb/Graff can solve. Right now, we have a convenience methods for building graphs from streams of odometry data (e.g. an LCM log or a ROS bag file).  \nWe also have lower-level methods, more generalized calls to add variables and factors."
},

{
    "location": "examples/basics_variablesandfactors.html#A-Quick-Discussion-on-IsReady-1",
    "page": "Building Graphs",
    "title": "A Quick Discussion on IsReady",
    "category": "section",
    "text": "Ideally, we want to solve any updated graph as quickly as possible. We\'re actually architecting the underlying solver structure to do that the moment new data becomes available, so in an ideal world, there is no such thing as a ready graph that doesn\'t have a solution yet.However, in some scenarios you want to incrementally build graphs and then let it solve. The IsReady flag on variables provides you with a means to delay that solving.In a simple scenario, imagine that you want to add two variables (x1 and x2) and relate them with a shared landmark. You may want to delay solving until you\'ve provided all the information. This can be done with the IsReady flag:Add x1 pose with isReady = false\nAdd x2 pose with isReady = false\nAdd l1 landmark with isReady = false\nCreate odometry factor between x1 and x2 (I moved from x1 to x2 and the new factor contains the odometry difference)\nCreate bearing+range factor between x1 and l1 (I saw something in x1)\nCreate bearing+range factor between x2 and l1 (I saw the same something in x2)\nCall PutReady for this set of nodes\n-> Solver will detect new data and run off to solve itLast note of this: Some methods automatically set IsReady to true (such as the addOdometryMeasurement convenience functions) - this is great for examples and continuous incremental solving. That means that you don\'t need to worry about it, and when we discuss those methods we\'ll try indicate which automatically set it."
},

{
    "location": "examples/basics_variablesandfactors.html#High-Level-Convenience-Functions-for-Adding-Data-to-a-Graff-1",
    "page": "Building Graphs",
    "title": "High-Level Convenience Functions for Adding Data to a Graff",
    "category": "section",
    "text": ""
},

{
    "location": "examples/basics_variablesandfactors.html#Adding-Odometry-Data-1",
    "page": "Building Graphs",
    "title": "Adding Odometry Data",
    "category": "section",
    "text": "Adding odometry data creates everything all at once for a standard 2D factor of type (x, y, angle). It creates a new variable (say x2) at the end of the graph, links it to the last variable (x1) via a Pose2Pose2 factor, and updates IsReady flags to true.Just create the AddOdometryRequest request and fire it off:deltaMeasurement = [1.0; 1.0; pi/4] # x2\'s pose is (1, 1) away from x1 and the bearing increased by 45 degrees   \npOdo = Float64[0.1 0 0; 0 0.1 0; 0 0 0.01] # Uncertainty in the measurement is in pOdo along the principal diagonal, i.e. [0.1, 0.1, 0.01]\nnewOdo = AddOdometryRequest(deltaMeasurement, pOdo)\n@show addOdoResponse = addOdometryMeasurement(synchronyConfig, newOdo)\n\n# Above would produce x1 in an empty graph.\n# Let\'s run again to produce x2 - assuming the robot travelled the same delta measurement\n@show addOdoResponse = addOdometryMeasurement(synchronyConfig, newOdo)The result would be the following image if run against an empty session:(Image: Simple Odometry Graph)"
},

{
    "location": "examples/basics_variablesandfactors.html#Adding-and-Attaching-Landmarks-1",
    "page": "Building Graphs",
    "title": "Adding and Attaching Landmarks",
    "category": "section",
    "text": "We may have seen the same identifying feature in both x1 and x2 (eg. an AprilTag), and want to represent this information. There is a convenience function addBearingRangeFactor that is used to add the factor between the landmark and the variable.Technically adding landmarks is a lower-level function (addVariable), but in this scenario we want to show the binding of the landmark to variables, so we need to add a landmark with a addVariable call:newLandmark = VariableRequest(\n  \"l1\", #The variables label\n  \"Point2\", #The type of variable - in this instance it\'s a 2D point in space, refer to Variable Types section below for the other variable types\n  [\"LANDMARK\"]) #Labels - we are identifying this as a landmark for readability\nresponse = addVariable(synchronyConfig, newLandmark)We now create the factors to link x1 to l1, and x2 to l1 respectively. The factors are type specific (in this case, relating a 2D position+angle to a 2D point), and include a distribution capturing the uncertainty. You don\'t need to make them normal distributions, but that\'s a discussion for later:newBearingRangeFactor = BearingRangeRequest(\"x1\", \"l1\",\n                          DistributionRequest(\"Normal\", Float64[0; 0.1]), # A statistical measurement of the bearing from x2 to l1 - normal distribution with 0 mean and 0.1 std\n                          DistributionRequest(\"Normal\", Float64[20; 1.0]) # A statistical measurement of the range/distance from x2 to l1 - normal distribution with 0 mean and 0.1 std\n                          )\naddBearingRangeFactor(synchronyConfig, newBearingRangeFactor)We can add another one between x2 and l1:newBearingRangeFactor = BearingRangeRequest(\"x2\", \"l1\",\n                          DistributionRequest(\"Normal\", Float64[-pi/4; 0.1]), # A statistical measurement of the bearing from x1 to l1 - normal distribution with 0 mean and 0.1 std\n                          DistributionRequest(\"Normal\", Float64[18; 1.0]) # A statistical measurement of the range/distance from x1 to l1 - normal distribution with 0 mean and 0.1 std\n                          )\naddBearingRangeFactor(synchronyConfig, newBearingRangeFactor)The graph then becomes:(Image: Odometry Graph with bound landmark)"
},

{
    "location": "examples/basics_variablesandfactors.html#Attaching-Sensor-Data-1",
    "page": "Building Graphs",
    "title": "Attaching Sensor Data",
    "category": "section",
    "text": "[TODO]"
},

{
    "location": "examples/basics_variablesandfactors.html#Low-Level-Functions-for-Adding-Data-to-a-Graff-1",
    "page": "Building Graphs",
    "title": "Low-Level Functions for Adding Data to a Graff",
    "category": "section",
    "text": ""
},

{
    "location": "examples/basics_variablesandfactors.html#Adding-Variables-1",
    "page": "Building Graphs",
    "title": "Adding Variables",
    "category": "section",
    "text": "Variables (a.k.a. poses in localization terminology) are created in the same way  shown above for the landmark. Variables contain a label, a data type (e.g. a 2D Point or Pose). Note that variables are solved - i.e. they are the product, what you wish to calculate when the solver runs - so you don\'t provide any measurements when creating them.For example, we can define x1 as follows:x1Request = VariableRequest(\"x1\", \"Pose2\")\nresponse = addVariable(synchronyConfig, x1Request)\n\nx2Request = VariableRequest(\"x2\", \"Pose2\", [\"AdditionalLabel\"])\nresponse = addVariable(synchronyConfig, x2Request)We can also provide additional labels in the request, as was done with the landmark, to help identify the variables later:newLandmark = VariableRequest(\"l1\", \"Point2\", [\"LANDMARK\"])\nresponse = addVariable(synchronyConfig, newLandmark)NOTE: These are by default created with IsReady set to false. The assumption is that you are building lower-level elements, so you should call putReady once you want these nodes to be solved."
},

{
    "location": "examples/basics_variablesandfactors.html#Variable-Types-1",
    "page": "Building Graphs",
    "title": "Variable Types",
    "category": "section",
    "text": "If you have installed RoME, you can check for the latest variable types with:using RoME\nsubtypes(IncrementalInference.InferenceVariable)The current list of available variable types is:Point2 - A 2D coordinate\nPoint3 - A 3D coordinate\nPose2 - A 2D coordinate and a rotation (i.e. bearing)\nPose3 - A 3D coordinate and 3 associated rotations\nDynPoint2 - A 2D coordinate and linear velocities\nDynPose2 - A 2D coordinate, linear velocities, and a rotation"
},

{
    "location": "examples/basics_variablesandfactors.html#Adding-Factors-1",
    "page": "Building Graphs",
    "title": "Adding Factors",
    "category": "section",
    "text": ""
},

{
    "location": "examples/basics_variablesandfactors.html#Creating-Factors-with-RoME-1",
    "page": "Building Graphs",
    "title": "Creating Factors with RoME",
    "category": "section",
    "text": "If you have RoME installed, you can lever the RoME library for creating various factors. To continue the prior example, to create the Pose2->Pose2 odometry relationship:using RoME\nusing Distributions\n\n# Our measurements\ndeltaMeasurement = [1.0; 1.0; pi/4] #Same as above - a (1,1) move with a 45 degree heading change\npOdo = Float64[0.1 0 0; 0 0.1 0; 0 0 0.01]\n# Creating the factor body - We are working on making this cleaner\np2p2 = Pose2Pose2(MvNormal(deltaMeasurement, pOdo.^2))\np2p2Conv = convert(PackedPose2Pose2, p2p2)\np2p2Request = FactorRequest([\"x0\", \"x1\"], \"Pose2Pose2\", p2p2Conv)\n\n# Send the request for the x0->x1 link\naddFactor(synchronyConfig, p2p2Request)\n# Update the request to make the same link between x1 and x2\np2p2Request.variables = [\"x1\", \"x2\"]\naddFactor(synchronyConfig, p2p2Request)Now we can add the factors between the variables and the landmark. As above, this is a 2D pose to 2D point+bearing factor, and is built similar to above:# Lastly, let\'s add the bearing+range factor between x1 and landmark l1\nbearingDist = Normal(-pi/4, 0.1)\nrangeDist = Normal(18, 1.0)\np2br2 = Pose2Point2BearingRange(bearingDist, rangeDist)\np2br2Conv = convert(PackedPose2Point2BearingRange, p2br2)\np2br2Request = FactorRequest([\"x1\", \"l1\"], \"Pose2Point2BearingRange\", p2br2Conv)\n\naddFactor(synchronyConfig, p2br2Request)\n# Now add the x1->l1 bearing+range factor\np2br2Request.variables = [\"x2\", \"l1\"]\naddFactor(synchronyConfig, p2br2Request)"
},

{
    "location": "examples/basics_variablesandfactors.html#Creating-Factors-Natively-1",
    "page": "Building Graphs",
    "title": "Creating Factors Natively",
    "category": "section",
    "text": "[TODO] In some instances, you are running a parallel local solver, so RoME will be available for factor creation. In other, smaller instances, you may rely solely on the cloud solution. In this case, you need to create factors without pulling in RoME. TBD - Still working on this."
},

{
    "location": "examples/basics_variablesandfactors.html#Factor-Types-1",
    "page": "Building Graphs",
    "title": "Factor Types",
    "category": "section",
    "text": "If you have installed RoME, you can check for the latest factor types with:using RoME\nsubtypes(IncrementalInference.FunctorPairwise)The current factor types that you will find in the example are (there are many aside from these):Point2Point2 -A factor between two 2D points\nPoint2Point2WorldBearing - A factor between two 2D points with bearing\nPose2Point2Bearing - A factor between two 2D points with bearing\nPose2Point2BearingRange - A factor between two 2D points with bearing and range\nPose2Point2Range - A factor between a 2D pose and a 2D point, with range\nPose2Pose2 - A factor between two 2D poses\nPose3Pose3 - A factor between two 3D poses"
},

{
    "location": "examples/hexagonal.html#",
    "page": "Hexagonal Robot",
    "title": "Hexagonal Robot",
    "category": "page",
    "text": ""
},

{
    "location": "examples/hexagonal.html#The-Hexagonal-Robot-Example-1",
    "page": "Hexagonal Robot",
    "title": "The Hexagonal Robot Example",
    "category": "section",
    "text": "Imagine a little wheeled robot driving in a circle. The tread measurement is a little sketchy, so as it progresses it gets a little less certain of where it is. But, each time it loops around, it\'s fairly certain it sees the same AprilTag. We construct this problem in SlamInDb/Graff, and show how the little guy is able to keep his cool as he progresses on his Sisyphean journey. Concepts highlighted:  Adding incremental odometry data\nAdding data to poses\nAdding factors like loop closures\nSolver robustness when contradictory data is provided\nVisualization"
},

{
    "location": "examples/hexagonal.html#Source-Code-1",
    "page": "Hexagonal Robot",
    "title": "Source Code",
    "category": "section",
    "text": "The complete source code for this example can be found at The Hexagonal Robot Example."
},

{
    "location": "examples/hexagonal.html#An-Overview-of-the-Example-1",
    "page": "Hexagonal Robot",
    "title": "An Overview of the Example",
    "category": "section",
    "text": ""
},

{
    "location": "examples/brookstone.html#",
    "page": "Brookstone Rover",
    "title": "Brookstone Rover",
    "category": "page",
    "text": ""
},

{
    "location": "examples/brookstone.html#Brookstone-Rover-Example-1",
    "page": "Brookstone Rover",
    "title": "Brookstone Rover Example",
    "category": "section",
    "text": "In the Brookstone Rover example we implement a real-world version of the Hexagonal example, and demonstrate batch-processing in Graff using a simple $100 robot. The robot is cheap, the data is messy, and we still a good solution. Concepts highlighted:     1. Integrating Graff with MIT\'s LCM to process an LCM log     1. Processing offline camera data     1. Visualization"
},

{
    "location": "examples/brookstone.html#Source-Code-1",
    "page": "Brookstone Rover",
    "title": "Source Code",
    "category": "section",
    "text": "The complete source code for this example can be found at Brookstone Rover Example."
},

{
    "location": "examples/brookstone.html#An-Overview-of-the-Example-1",
    "page": "Brookstone Rover",
    "title": "An Overview of the Example",
    "category": "section",
    "text": ""
},

{
    "location": "ref_user.html#",
    "page": "User Service",
    "title": "User Service",
    "category": "page",
    "text": ""
},

{
    "location": "ref_user.html#User-Service-1",
    "page": "User Service",
    "title": "User Service",
    "category": "section",
    "text": "User calls are used to create, update, retrieve, or delete users from Synchrony. It is also used to retrieve runtime configuration information per user (e.g. streaming connection information)."
},

{
    "location": "ref_user.html#GraffSDK.UserRequest",
    "page": "User Service",
    "title": "GraffSDK.UserRequest",
    "category": "type",
    "text": "The structure used for user requests.\n\n\n\n"
},

{
    "location": "ref_user.html#GraffSDK.UserResponse",
    "page": "User Service",
    "title": "GraffSDK.UserResponse",
    "category": "type",
    "text": "The response structure for user calls.\n\n\n\n"
},

{
    "location": "ref_user.html#User-Structures-1",
    "page": "User Service",
    "title": "User Structures",
    "category": "section",
    "text": "UserRequest\nUserResponse"
},

{
    "location": "ref_user.html#GraffSDK.getUser",
    "page": "User Service",
    "title": "GraffSDK.getUser",
    "category": "function",
    "text": "getUser(config, userId)\n\n\nGets a user given the user ID. Return: The user for the given user ID.\n\n\n\n"
},

{
    "location": "ref_user.html#GraffSDK.updateUser",
    "page": "User Service",
    "title": "GraffSDK.updateUser",
    "category": "function",
    "text": "updateUser(config, user)\n\n\nUpdate a user. Return: The updated user from the service.\n\n\n\n"
},

{
    "location": "ref_user.html#GraffSDK.deleteUser",
    "page": "User Service",
    "title": "GraffSDK.deleteUser",
    "category": "function",
    "text": "deleteUser(config, userId)\n\n\nDelete a user given a user ID. NOTE: All robots must be deleted first, the call will fail if robots are still associated to the user. Return: The deleted user.\n\n\n\n"
},

{
    "location": "ref_user.html#User-Functions-1",
    "page": "User Service",
    "title": "User Functions",
    "category": "section",
    "text": "getUser\nupdateUser\ndeleteUser"
},

{
    "location": "ref_robot.html#",
    "page": "Robot Service",
    "title": "Robot Service",
    "category": "page",
    "text": ""
},

{
    "location": "ref_robot.html#Robot-Service-1",
    "page": "Robot Service",
    "title": "Robot Service",
    "category": "section",
    "text": "Robot calls are used to create, update, retrieve, or delete robots related to users in the GraffSDK."
},

{
    "location": "ref_robot.html#GraffSDK.RobotRequest",
    "page": "Robot Service",
    "title": "GraffSDK.RobotRequest",
    "category": "type",
    "text": "The structure used for robot requests.\n\n\n\n"
},

{
    "location": "ref_robot.html#GraffSDK.RobotResponse",
    "page": "Robot Service",
    "title": "GraffSDK.RobotResponse",
    "category": "type",
    "text": "The structure returned when any robot requests are made.\n\n\n\n"
},

{
    "location": "ref_robot.html#GraffSDK.RobotsResponse",
    "page": "Robot Service",
    "title": "GraffSDK.RobotsResponse",
    "category": "type",
    "text": "A list of robots provided by the /robots request.\n\n\n\n"
},

{
    "location": "ref_robot.html#Robot-Structures-1",
    "page": "Robot Service",
    "title": "Robot Structures",
    "category": "section",
    "text": "RobotRequest\nRobotResponse\nRobotsResponse"
},

{
    "location": "ref_robot.html#GraffSDK.getRobots",
    "page": "Robot Service",
    "title": "GraffSDK.getRobots",
    "category": "function",
    "text": "getRobots(config)\n\n\nGets all robots managed by the specified user. Return: A vector of robots for a given user.\n\n\n\n"
},

{
    "location": "ref_robot.html#GraffSDK.isRobotExisting",
    "page": "Robot Service",
    "title": "GraffSDK.isRobotExisting",
    "category": "function",
    "text": "isRobotExisting(config, robotId)\n\n\nReturn: Returns true if the robot exists already.\n\n\n\nisRobotExisting(config)\n\n\nReturn: Returns true if the robot in the config exists already.\n\n\n\n"
},

{
    "location": "ref_robot.html#GraffSDK.getRobot",
    "page": "Robot Service",
    "title": "GraffSDK.getRobot",
    "category": "function",
    "text": "getRobot(config, robotId)\n\n\nGet a specific robot given a user ID and robot ID. Will retrieve config.robotId by default. Return: The robot for the provided user ID and robot ID.\n\n\n\ngetRobot(config)\n\n\nGet a specific robot given a user ID and robot ID. Will retrieve config.robotId by default. Return: The robot for the provided user ID and robot ID.\n\n\n\n"
},

{
    "location": "ref_robot.html#GraffSDK.addRobot",
    "page": "Robot Service",
    "title": "GraffSDK.addRobot",
    "category": "function",
    "text": "addRobot(config, robot)\n\n\nCreate a robot in Synchrony and associate it with the given user. Return: Returns the created robot.\n\n\n\n"
},

{
    "location": "ref_robot.html#GraffSDK.updateRobot",
    "page": "Robot Service",
    "title": "GraffSDK.updateRobot",
    "category": "function",
    "text": "updateRobot(config, robot)\n\n\nUpdate a robot. Return: The updated robot from the service.\n\n\n\n"
},

{
    "location": "ref_robot.html#GraffSDK.deleteRobot",
    "page": "Robot Service",
    "title": "GraffSDK.deleteRobot",
    "category": "function",
    "text": "deleteRobot(config, robotId)\n\n\nDelete a robot given a robot ID. Return: The deleted robot.\n\n\n\n"
},

{
    "location": "ref_robot.html#Robot-Functions-1",
    "page": "Robot Service",
    "title": "Robot Functions",
    "category": "section",
    "text": "getRobots\nisRobotExisting\ngetRobot\naddRobot\nupdateRobot\ndeleteRobot"
},

{
    "location": "ref_robot.html#GraffSDK.getRobotConfig",
    "page": "Robot Service",
    "title": "GraffSDK.getRobotConfig",
    "category": "function",
    "text": "getRobotConfig(config, robotId)\n\n\nWill retrieve the robot configuration (user settings) for the given robot ID. Return: The robot config for the provided user ID and robot ID.\n\n\n\ngetRobotConfig(config)\n\n\nWill retrieve the robot configuration (user settings) for the default robot ID. Return: The robot config for the provided user ID and robot ID.\n\n\n\n"
},

{
    "location": "ref_robot.html#GraffSDK.updateRobotConfig",
    "page": "Robot Service",
    "title": "GraffSDK.updateRobotConfig",
    "category": "function",
    "text": "updateRobotConfig(config, robotId, robotConfig)\n\n\nUpdate a robot configuration. Return: The updated robot configuration from the service.\n\n\n\nupdateRobotConfig(config, robotConfig)\n\n\nUpdate a robot configuration. Return: The updated robot configuration from the service.\n\n\n\n"
},

{
    "location": "ref_robot.html#Robot-Configuration-Functions-1",
    "page": "Robot Service",
    "title": "Robot Configuration Functions",
    "category": "section",
    "text": "getRobotConfig\nupdateRobotConfig"
},

{
    "location": "ref_session.html#",
    "page": "Session Service",
    "title": "Session Service",
    "category": "page",
    "text": ""
},

{
    "location": "ref_session.html#Session-Service-1",
    "page": "Session Service",
    "title": "Session Service",
    "category": "section",
    "text": "Session calls are used to ingest or retrieve runtime data from Graff. Every running robot saves data against a session, and the Session calls allow a user to retrieve data across all sessions."
},

{
    "location": "ref_session.html#Interacting-with-Sessions-1",
    "page": "Session Service",
    "title": "Interacting with Sessions",
    "category": "section",
    "text": ""
},

{
    "location": "ref_session.html#GraffSDK.SessionResponse",
    "page": "Session Service",
    "title": "GraffSDK.SessionResponse",
    "category": "type",
    "text": "A summary response for a single session.\n\n\n\n"
},

{
    "location": "ref_session.html#GraffSDK.SessionsResponse",
    "page": "Session Service",
    "title": "GraffSDK.SessionsResponse",
    "category": "type",
    "text": "A list of session response summaries.\n\n\n\n"
},

{
    "location": "ref_session.html#GraffSDK.SessionDetailsRequest",
    "page": "Session Service",
    "title": "GraffSDK.SessionDetailsRequest",
    "category": "type",
    "text": "The structure used for detailed session requests.\n\n\n\n"
},

{
    "location": "ref_session.html#GraffSDK.SessionDetailsResponse",
    "page": "Session Service",
    "title": "GraffSDK.SessionDetailsResponse",
    "category": "type",
    "text": "The structure used for detailed session responses.\n\n\n\n"
},

{
    "location": "ref_session.html#Structures-1",
    "page": "Session Service",
    "title": "Structures",
    "category": "section",
    "text": "SessionResponse\nSessionsResponse\nSessionDetailsRequest\nSessionDetailsResponse"
},

{
    "location": "ref_session.html#GraffSDK.getSessions",
    "page": "Session Service",
    "title": "GraffSDK.getSessions",
    "category": "function",
    "text": "getSessions(config, robotId)\n\n\nGets all sessions for the current robot. Return: A vector of sessions for the current robot.\n\n\n\ngetSessions(config)\n\n\nGets all sessions for the current robot. Return: A vector of sessions for the current robot.\n\n\n\n"
},

{
    "location": "ref_session.html#GraffSDK.isSessionExisting",
    "page": "Session Service",
    "title": "GraffSDK.isSessionExisting",
    "category": "function",
    "text": "isSessionExisting(config, robotId, sessionId)\n\n\nReturn: Returns true if the session exists already.\n\n\n\nisSessionExisting(config)\n\n\nReturn: Returns true if the session exists already.\n\n\n\n"
},

{
    "location": "ref_session.html#GraffSDK.getSession",
    "page": "Session Service",
    "title": "GraffSDK.getSession",
    "category": "function",
    "text": "getSession(config, robotId, sessionId)\n\n\nGet a specific session given a user ID, robot ID, and session ID. Return: The session details for the provided user ID, robot ID, and session ID.\n\n\n\ngetSession(config)\n\n\nGet a specific session given a user ID, robot ID, and session ID. Return: The session details for the provided user ID, robot ID, and session ID.\n\n\n\n"
},

{
    "location": "ref_session.html#GraffSDK.deleteSession",
    "page": "Session Service",
    "title": "GraffSDK.deleteSession",
    "category": "function",
    "text": "deleteSession(config, robotId, sessionId)\n\n\nDelete a specific session given a user ID, robot ID, and session ID. Return: Nothing if success, error if failed.\n\n\n\ndeleteSession(config)\n\n\nDelete a specific session given a user ID, robot ID, and session ID. Return: Nothing if success, error if failed.\n\n\n\n"
},

{
    "location": "ref_session.html#GraffSDK.addSession",
    "page": "Session Service",
    "title": "GraffSDK.addSession",
    "category": "function",
    "text": "addSession(config, robotId, session)\n\n\nCreate a session in Synchrony and associate it with the given robot+user. Return: Returns the created session.\n\n\n\naddSession(config, session)\n\n\nCreate a session in Synchrony and associate it with the given robot+user. Return: Returns the created session.\n\n\n\n"
},

{
    "location": "ref_session.html#Functions-1",
    "page": "Session Service",
    "title": "Functions",
    "category": "section",
    "text": "getSessions\nisSessionExisting\ngetSession\ndeleteSession\naddSession"
},

{
    "location": "ref_session.html#Getting-Graphs-Getting-Session-Nodes-1",
    "page": "Session Service",
    "title": "Getting Graphs - Getting Session Nodes",
    "category": "section",
    "text": ""
},

{
    "location": "ref_session.html#GraffSDK.NodeResponse",
    "page": "Session Service",
    "title": "GraffSDK.NodeResponse",
    "category": "type",
    "text": "The structure used to briefly describe a node in a response.\n\n\n\n"
},

{
    "location": "ref_session.html#GraffSDK.NodesResponse",
    "page": "Session Service",
    "title": "GraffSDK.NodesResponse",
    "category": "type",
    "text": "The structure used to briefly describe a set of nodes in a response.\n\n\n\n"
},

{
    "location": "ref_session.html#GraffSDK.NodeDetailsResponse",
    "page": "Session Service",
    "title": "GraffSDK.NodeDetailsResponse",
    "category": "type",
    "text": "The structure describing a complete node in a response.\n\n\n\n"
},

{
    "location": "ref_session.html#Structures-2",
    "page": "Session Service",
    "title": "Structures",
    "category": "section",
    "text": "NodeResponse\nNodesResponse\nNodeDetailsResponse"
},

{
    "location": "ref_session.html#GraffSDK.getNodes",
    "page": "Session Service",
    "title": "GraffSDK.getNodes",
    "category": "function",
    "text": "getNodes(config, robotId, sessionId)\n\n\nGets all nodes for a given session. Return: A vector of nodes for a given robot.\n\n\n\ngetNodes(config)\n\n\nGets all nodes for a given session. Return: A vector of nodes for a given robot.\n\n\n\n"
},

{
    "location": "ref_session.html#GraffSDK.getNode",
    "page": "Session Service",
    "title": "GraffSDK.getNode",
    "category": "function",
    "text": "getNode(config, robotId, sessionId, nodeIdOrLabel)\n\n\nGets a node\'s details by either its ID or name. Return: A node\'s details.\n\n\n\ngetNode(config, nodeIdOrLabel)\n\n\nGets a node\'s details by either its ID or name. Return: A node\'s details.\n\n\n\n"
},

{
    "location": "ref_session.html#Functions-2",
    "page": "Session Service",
    "title": "Functions",
    "category": "section",
    "text": "getNodes\ngetNode"
},

{
    "location": "ref_session.html#Building-Graphs-Adding-Nodes/Variables/Factors-1",
    "page": "Session Service",
    "title": "Building Graphs - Adding Nodes/Variables/Factors",
    "category": "section",
    "text": ""
},

{
    "location": "ref_session.html#Structures-3",
    "page": "Session Service",
    "title": "Structures",
    "category": "section",
    "text": "NodeResponse\nNodesResponse\nNodeDetailsResponse\nAddOdometryRequest\nAddOdometryResponse\nVariableRequest\nVariableResponse\nDistributionRequest\nBearingRangeRequest\nFactorBody\nFactorRequest"
},

{
    "location": "ref_session.html#GraffSDK.addVariable",
    "page": "Session Service",
    "title": "GraffSDK.addVariable",
    "category": "function",
    "text": "addVariable(config, robotId, sessionId, variableRequest)\n\n\nCreate a variable in Synchrony. Return: Returns the ID+label of the created variable.\n\n\n\naddVariable(config, variableRequest)\n\n\nCreate a variable in Synchrony. Return: Returns the ID+label of the created variable.\n\n\n\n"
},

{
    "location": "ref_session.html#GraffSDK.addFactor",
    "page": "Session Service",
    "title": "GraffSDK.addFactor",
    "category": "function",
    "text": "addFactor(config, robotId, sessionId, factorRequest)\n\n\nCreate a factor in Synchrony. Return: Returns the ID+label of the created factor.\n\n\n\naddFactor(config, factorRequest)\n\n\nCreate a factor in Synchrony. Return: Returns the ID+label of the created factor.\n\n\n\n"
},

{
    "location": "ref_session.html#GraffSDK.addBearingRangeFactor",
    "page": "Session Service",
    "title": "GraffSDK.addBearingRangeFactor",
    "category": "function",
    "text": "addBearingRangeFactor(config, robotId, sessionId, bearingRangeRequest)\n\n\nCreate a variable in Synchrony and associate it with the given robot+user. Return: Returns ID+label of the created factor.\n\n\n\naddBearingRangeFactor(config, bearingRangeRequest)\n\n\nCreate a variable in Synchrony and associate it with the given robot+user. Return: Returns ID+label of the created factor.\n\n\n\n"
},

{
    "location": "ref_session.html#GraffSDK.addOdometryMeasurement",
    "page": "Session Service",
    "title": "GraffSDK.addOdometryMeasurement",
    "category": "function",
    "text": "addOdometryMeasurement(config, robotId, sessionId, addOdoRequest)\n\n\nCreate a session in Synchrony and associate it with the given robot+user. Return: Returns the added odometry information.\n\n\n\naddOdometryMeasurement(config, addOdoRequest)\n\n\nCreate a session in Synchrony and associate it with the given robot+user. Return: Returns the added odometry information.\n\n\n\n"
},

{
    "location": "ref_session.html#GraffSDK.putReady",
    "page": "Session Service",
    "title": "GraffSDK.putReady",
    "category": "function",
    "text": "putReady(config, robotId, sessionId, isReady)\n\n\nSet the ready status for a session.\n\n\n\nputReady(config, isReady)\n\n\nSet the ready status for a session.\n\n\n\n"
},

{
    "location": "ref_session.html#Functions-3",
    "page": "Session Service",
    "title": "Functions",
    "category": "section",
    "text": "addVariable\naddFactor\naddBearingRangeFactor\naddOdometryMeasurement\nputReady"
},

{
    "location": "ref_session.html#Working-with-Node-Data-1",
    "page": "Session Service",
    "title": "Working with Node Data",
    "category": "section",
    "text": ""
},

{
    "location": "ref_session.html#GraffSDK.BigDataElementRequest",
    "page": "Session Service",
    "title": "GraffSDK.BigDataElementRequest",
    "category": "type",
    "text": "Body of a request for creating or updating a data element.\n\n\n\n"
},

{
    "location": "ref_session.html#GraffSDK.BigDataEntryResponse",
    "page": "Session Service",
    "title": "GraffSDK.BigDataEntryResponse",
    "category": "type",
    "text": "Summary of data entry returned from request.\n\n\n\n"
},

{
    "location": "ref_session.html#GraffSDK.BigDataElementResponse",
    "page": "Session Service",
    "title": "GraffSDK.BigDataElementResponse",
    "category": "type",
    "text": "Complete data element response (including data).\n\n\n\n"
},

{
    "location": "ref_session.html#Structures-4",
    "page": "Session Service",
    "title": "Structures",
    "category": "section",
    "text": "BigDataElementRequest\nBigDataEntryResponse\nBigDataElementResponse"
},

{
    "location": "ref_session.html#GraffSDK.getDataEntries",
    "page": "Session Service",
    "title": "GraffSDK.getDataEntries",
    "category": "function",
    "text": "getDataEntries(config, robotId, sessionId, node)\n\n\nGet data entries associated with a node. Return: Summary of all data associated with a node.\n\n\n\ngetDataEntries(config, node)\n\n\nGet data entries associated with a node. Return: Summary of all data associated with a node.\n\n\n\n"
},

{
    "location": "ref_session.html#GraffSDK.getDataElement",
    "page": "Session Service",
    "title": "GraffSDK.getDataElement",
    "category": "function",
    "text": "getDataElement(config, robotId, sessionId, node, bigDataKey)\n\n\nGet data elment associated with a node. Return: Full data element associated with the specified node.\n\n\n\ngetDataElement(config, node, bigDataKey)\n\n\nGet data elment associated with a node. Return: Full data element associated with the specified node.\n\n\n\n"
},

{
    "location": "ref_session.html#GraffSDK.getRawDataElement",
    "page": "Session Service",
    "title": "GraffSDK.getRawDataElement",
    "category": "function",
    "text": "getRawDataElement(config, robotId, sessionId, node, bigDataKey)\n\n\nGet data elment associated with a node. Return: Full data element associated with the specified node.\n\n\n\ngetRawDataElement(config, node, bigDataKey)\n\n\nGet data elment associated with a node. Return: Full data element associated with the specified node.\n\n\n\n"
},

{
    "location": "ref_session.html#GraffSDK.addDataElement",
    "page": "Session Service",
    "title": "GraffSDK.addDataElement",
    "category": "function",
    "text": "addDataElement(config, robotId, sessionId, node, bigDataElement)\n\n\nAdd a data element associated with a node. Return: Nothing if succeed, error if failed.\n\n\n\naddDataElement(config, node, bigDataElement)\n\n\nAdd a data element associated with a node. Return: Nothing if succeed, error if failed.\n\n\n\n"
},

{
    "location": "ref_session.html#GraffSDK.updateDataElement",
    "page": "Session Service",
    "title": "GraffSDK.updateDataElement",
    "category": "function",
    "text": "updateDataElement(config, robotId, sessionId, node, bigDataElement)\n\n\nUpdate a data element associated with a node. Return: Nothing if succeed, error if failed.\n\n\n\nupdateDataElement(config, node, bigDataElement)\n\n\nUpdate a data element associated with a node. Return: Nothing if succeed, error if failed.\n\n\n\n"
},

{
    "location": "ref_session.html#GraffSDK.addOrUpdateDataElement",
    "page": "Session Service",
    "title": "GraffSDK.addOrUpdateDataElement",
    "category": "function",
    "text": "addOrUpdateDataElement(config, robotId, sessionId, node, dataElement)\n\n\nAdd or update a data element associated with a node. Will check if the key exists, if so it updates, otherwise it adds. Return: Nothing if succeed, error if failed.\n\n\n\n"
},

{
    "location": "ref_session.html#GraffSDK.deleteDataElement",
    "page": "Session Service",
    "title": "GraffSDK.deleteDataElement",
    "category": "function",
    "text": "deleteDataElement(config, robotId, sessionId, node, dataId)\n\n\nDelete a data element associated with a node. Return: Nothing if succeed, error if failed.\n\n\n\ndeleteDataElement(config, node, dataId)\n\n\nDelete a data element associated with a node. Return: Nothing if succeed, error if failed.\n\n\n\n"
},

{
    "location": "ref_session.html#Functions-4",
    "page": "Session Service",
    "title": "Functions",
    "category": "section",
    "text": "getDataEntries\ngetDataElement\ngetRawDataElement\naddDataElement\nupdateDataElement\naddOrUpdateDataElement\ndeleteDataElement"
},

{
    "location": "reference.html#",
    "page": "Reference",
    "title": "Reference",
    "category": "page",
    "text": ""
},

{
    "location": "reference.html#Reference-1",
    "page": "Reference",
    "title": "Reference",
    "category": "section",
    "text": "Pages = [\n    \"func_ref.md\"\n]\nDepth = 3"
},

]}
