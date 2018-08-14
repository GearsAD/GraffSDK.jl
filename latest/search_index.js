var documenterSearchIndex = {"docs": [

{
    "location": "index.html#",
    "page": "Home",
    "title": "Home",
    "category": "page",
    "text": ""
},

{
    "location": "index.html#Synchrony-Examples-1",
    "page": "Home",
    "title": "Synchrony Examples",
    "category": "section",
    "text": "This package is an SDK for the Project Synchrony API."
},

{
    "location": "index.html#Installation-1",
    "page": "Home",
    "title": "Installation",
    "category": "section",
    "text": "This package is not yet registered with JuliaLang/METADATA.jl, but can be easily installed in Julia 0.6 with:Pkg.clone(\"https://github.com/GearsAD/SynchronySDK.jl.git\")\nPkg.build(\"SynchronySDK\")"
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
    "page": "Getting Started",
    "title": "Getting Started",
    "category": "page",
    "text": ""
},

{
    "location": "getting_started.html#Getting-Started-with-Synchrony-SDK-1",
    "page": "Getting Started",
    "title": "Getting Started with Synchrony SDK",
    "category": "section",
    "text": "This documents the steps for using the SDK, as shown in the examples folder.This example will walk through the following steps, demonstrating how you can manage, ingest, and extract data for your robots:Loading a Synchrony configuration\nGetting your user information and runtime configuration\nCreating a robot that will produce data and ingest it into Synchrony\nCreating a new robot session\nImporting data into the new session\nRunning the solver to refine the graph\nViewing the results of the SLAM solutionThe first step is to create a new script file and import the base libraries:using Base\nusing SynchronySDK"
},

{
    "location": "getting_started.html#Loading-a-Synchrony-Configuration-1",
    "page": "Getting Started",
    "title": "Loading a Synchrony Configuration",
    "category": "section",
    "text": "In the same location as the new script, create a file called \'synchronyConfig.json\', and paste in your Synchrony endpoint which was provided when you created your account:{\n  \"apiEndpoint\":\"http://myserver...\",\n  \"apiPort\":8000\n}It is assumed that Julia was started in the same folder as the script, so add the following code to the script to load the configuration:# 1. Get a Synchrony configuration\n# Assume that you\'re running in local directory\nconfigFile = open(\"synchronyConfig.json\")\nconfigData = JSON.parse(readstring(configFile))\nclose(configFile)\nsynchronyConfig = Unmarshal.unmarshal(SynchronyConfig, configData)"
},

{
    "location": "getting_started.html#Creating-a-Token-1",
    "page": "Getting Started",
    "title": "Creating a Token",
    "category": "section",
    "text": "Next step is to create a token for your user. Add the following code with your user and API key:# 2. Authorizing ourselves for requests\nauthRequest = AuthRequest(\"user\", \"apiKey\")\nauth = authenticate(synchronyConfig, authRequest)This will fire off an authentication request, and return an AuthRespose that contains a token."
},

{
    "location": "getting_started.html#Getting-your-User-and-Runtime-Configuration-Information-1",
    "page": "Getting Started",
    "title": "Getting your User and Runtime Configuration Information",
    "category": "section",
    "text": "Users maintain the runtime configuration, which is the connection information to ingest data as well as receive notifications when the graph is updated.Just to confirm our user information, we do the following:userId = \"myUserId\" #TODO: Replace with your user ID\nuser = getUser(synchronyConfig, auth, myUserId)The \'user\' variable should contain all our account information. This isn\'t a necessary step, but helps us check a new user account to make sure all is correct.We do need to get the runtime information to subscribe to notifications and ingest data though, so let\'s retrieve the runtime configuration for this user:# 3. Config retrieval\n# This contains all the parameters required to ingest or retrieve\n# data from the system.\nruntimeConfig = getUserConfig(synchronyConfig, auth, userId)We can now use the runtime configuration to ingest data for a given robot as well as subscribe for graph updates. Firstly though, we need to create robot and a new session for the data."
},

{
    "location": "getting_started.html#Creating-a-Robot-1",
    "page": "Getting Started",
    "title": "Creating a Robot",
    "category": "section",
    "text": "Users manage robots, and in this example we have assumed that your user currently has no robots assigned to them. Let\'s create a robot!TODO"
},

{
    "location": "getting_started.html#Creating-a-New-Session-1",
    "page": "Getting Started",
    "title": "Creating a New Session",
    "category": "section",
    "text": ""
},

{
    "location": "getting_started.html#Importing-Data-into-the-New-Session-1",
    "page": "Getting Started",
    "title": "Importing Data into the New Session",
    "category": "section",
    "text": "TODO"
},

{
    "location": "examples.html#",
    "page": "Examples",
    "title": "Examples",
    "category": "page",
    "text": ""
},

{
    "location": "examples.html#Navi-SDK-1",
    "page": "Examples",
    "title": "Navi SDK",
    "category": "section",
    "text": "This package is an SDK for the Navi API."
},

{
    "location": "examples.html#Installation-1",
    "page": "Examples",
    "title": "Installation",
    "category": "section",
    "text": "This package is not yet registered with JuliaLang/METADATA.jl, but can be easily installed in Julia 0.6 with:Pkg.clone(\"https://github.com/GearsAD/NaviSDK.jl.git\")\nPkg.build(\"NaviSDK\")"
},

{
    "location": "examples.html#Manual-Outline-1",
    "page": "Examples",
    "title": "Manual Outline",
    "category": "section",
    "text": "Pages = [\n    \"index.md\"\n    \"getting_started.md\"\n    \"ref_user.md\"\n    \"ref_robot.md\"\n    \"ref_session.md\"\n    \"reference.md\"\n]"
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
    "location": "ref_common.html#Common-Structures-1",
    "page": "Common Structures and Functions",
    "title": "Common Structures",
    "category": "section",
    "text": "SynchronyConfig\nErrorResponse"
},

{
    "location": "ref_common.html#Common-Functions-1",
    "page": "Common Structures and Functions",
    "title": "Common Functions",
    "category": "section",
    "text": ""
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
    "location": "ref_user.html#User-Structures-1",
    "page": "User Service",
    "title": "User Structures",
    "category": "section",
    "text": "UserRequest\nUserResponse\nUserConfig\nKafkaConfig\nErrorResponse"
},

{
    "location": "ref_user.html#User-Functions-1",
    "page": "User Service",
    "title": "User Functions",
    "category": "section",
    "text": "createUser\ngetUser\nupdateUser\ndeleteUser\ngetUserConfig"
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
    "text": "Robot calls are used to create, update, retrieve, or delete robots related to users in Synchrony."
},

{
    "location": "ref_robot.html#SynchronySDK.RobotRequest",
    "page": "Robot Service",
    "title": "SynchronySDK.RobotRequest",
    "category": "type",
    "text": "The structure used for robot requests.\n\n\n\n"
},

{
    "location": "ref_robot.html#SynchronySDK.RobotResponse",
    "page": "Robot Service",
    "title": "SynchronySDK.RobotResponse",
    "category": "type",
    "text": "The structure returned when any robot requests are made.\n\n\n\n"
},

{
    "location": "ref_robot.html#SynchronySDK.RobotsResponse",
    "page": "Robot Service",
    "title": "SynchronySDK.RobotsResponse",
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
    "location": "ref_robot.html#Robot-Functions-1",
    "page": "Robot Service",
    "title": "Robot Functions",
    "category": "section",
    "text": "getRobots\ngetRobot\ncreateRobot\nupdateRobot\ndeleteRobot"
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
    "text": "Session calls are used to ingest or retrieve runtime data from Synchrony. Every running robot saves data against a session, and the Session calls allow a user to retrieve data across all sessions."
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
