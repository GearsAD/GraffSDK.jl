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
    "text": "Pages = [\n    \"index.md\"\n    \"getting_started.md\"\n    \"ref_user.md\"\n    \"ref_robot.md\"\n    \"ref_session.md\"\n    \"reference.md\"\n]"
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
