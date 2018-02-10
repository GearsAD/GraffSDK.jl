var documenterSearchIndex = {"docs": [

{
    "location": "index.html#",
    "page": "Home",
    "title": "Home",
    "category": "page",
    "text": ""
},

{
    "location": "index.html#Synchrony-SDK-1",
    "page": "Home",
    "title": "Synchrony SDK",
    "category": "section",
    "text": "This package is a ccall wrapper for the AprilTags library tailored for Julia."
},

{
    "location": "index.html#Installation-1",
    "page": "Home",
    "title": "Installation",
    "category": "section",
    "text": "This package is not yet registered with JuliaLang/METADATA.jl, but can be easily installed in Julia 0.6 with:Pkg.clone(\"https://github.com/Affie/AprilTags.jl.git\")\nPkg.build(\"AprilTags\")"
},

{
    "location": "index.html#Usage-1",
    "page": "Home",
    "title": "Usage",
    "category": "section",
    "text": ""
},

{
    "location": "index.html#Examples-1",
    "page": "Home",
    "title": "Examples",
    "category": "section",
    "text": "See examples and test folder for basic AprilTag usage examples."
},

{
    "location": "index.html#Initialization-1",
    "page": "Home",
    "title": "Initialization",
    "category": "section",
    "text": "Initialize a detector with the default (tag36h11) tag family.# Create default detector\ndetector = AprilTagDetector()Some tag detector parameters can be set at this time. The default parameters are the recommended starting point.AprilTags.setnThreads(detector, 4)\nAprilTags.setquad_decimate(detector, 1.0)\nAprilTags.setquad_sigma(detector,0.0)\nAprilTags.setrefine_edges(detector,1)\nAprilTags.setrefine_decode(detector,0)\nAprilTags.setrefine_pose(detector,0)Increase the image decimation if faster processing is required; the trade-off is a slight decrease in detection range. A factor of 1.0 means the full-size input image is used.Some Gaussian blur (quad_sigma) may help with noisy input images."
},

{
    "location": "index.html#Detection-1",
    "page": "Home",
    "title": "Detection",
    "category": "section",
    "text": "Process an input image and return a vector of detections. The input image can be loaded with the Images package.image = load(\"example_image.jpg\")\ntags = detector(image)\n#do something with tags hereThe caller is responsible for freeing the memmory by callingfreeDetector!(detector)"
},

{
    "location": "index.html#Manual-Outline-1",
    "page": "Home",
    "title": "Manual Outline",
    "category": "section",
    "text": "Pages = [\n    \"index.md\"\n    \"func_ref.md\"\n    \"reference.md\"\n]"
},

{
    "location": "func_ref.html#",
    "page": "Function Calls",
    "title": "Function Calls",
    "category": "page",
    "text": ""
},

{
    "location": "func_ref.html#SDK-Functionality-1",
    "page": "Function Calls",
    "title": "SDK Functionality",
    "category": "section",
    "text": "The Synchrony SDK is split into the following functional groups:Authentication and authorization calls\nUser calls\nRobot calls\nSession calls\nCyphon calls"
},

{
    "location": "func_ref.html#Authentication-and-Authorization-1",
    "page": "Function Calls",
    "title": "Authentication and Authorization",
    "category": "section",
    "text": "Authentication and authorization calls are the first step in connecting to Synchrony. The calls are used to create tokens used for subsequent API calls."
},

{
    "location": "func_ref.html#SynchronySDK.AuthRequest",
    "page": "Function Calls",
    "title": "SynchronySDK.AuthRequest",
    "category": "Type",
    "text": "The structure used to perform an authentication request.\n\n\n\n"
},

{
    "location": "func_ref.html#SynchronySDK.AuthResponse",
    "page": "Function Calls",
    "title": "SynchronySDK.AuthResponse",
    "category": "Type",
    "text": "The structure returned from an authentication call.\n\n\n\n"
},

{
    "location": "func_ref.html#Auth-Structures-1",
    "page": "Function Calls",
    "title": "Auth Structures",
    "category": "section",
    "text": "AuthRequest\nAuthResponse"
},

{
    "location": "func_ref.html#SynchronySDK.authenticate",
    "page": "Function Calls",
    "title": "SynchronySDK.authenticate",
    "category": "Function",
    "text": "authenticate(config::SynchronyConfig, authRequest::AuthRequest)::AuthResponse\n\nAuthenticates a user and produces a token for further user. Return: The authentication token.\n\n\n\n"
},

{
    "location": "func_ref.html#SynchronySDK.refreshToken",
    "page": "Function Calls",
    "title": "SynchronySDK.refreshToken",
    "category": "Function",
    "text": "refreshToken(config::SynchronyConfig, authResponse::AuthResponse)::AuthResponse\n\nRefreshes a token from an older token. Use this when the token is about to expire. Return: The updated token.\n\n\n\n"
},

{
    "location": "func_ref.html#Auth-Functions-1",
    "page": "Function Calls",
    "title": "Auth Functions",
    "category": "section",
    "text": "authenticate\nrefreshToken"
},

{
    "location": "func_ref.html#User-1",
    "page": "Function Calls",
    "title": "User",
    "category": "section",
    "text": "User calls are used to create, update, retrieve, or delete users from Synchrony. It is also used to retrieve runtime configuration information per user (e.g. streaming connection information)."
},

{
    "location": "func_ref.html#SynchronySDK.UserRequest",
    "page": "Function Calls",
    "title": "SynchronySDK.UserRequest",
    "category": "Type",
    "text": "The structure used for user requests.\n\n\n\n"
},

{
    "location": "func_ref.html#SynchronySDK.UserResponse",
    "page": "Function Calls",
    "title": "SynchronySDK.UserResponse",
    "category": "Type",
    "text": "The response structure for user calls.\n\n\n\n"
},

{
    "location": "func_ref.html#SynchronySDK.UserConfig",
    "page": "Function Calls",
    "title": "SynchronySDK.UserConfig",
    "category": "Type",
    "text": "Runtime configuration parameters for connecting to the Synchrony API.\n\n\n\n"
},

{
    "location": "func_ref.html#SynchronySDK.KafkaConfig",
    "page": "Function Calls",
    "title": "SynchronySDK.KafkaConfig",
    "category": "Type",
    "text": "Runtime configuration parameters for connecting to the streaming API.\n\n\n\n"
},

{
    "location": "func_ref.html#SynchronySDK.ErrorResponse",
    "page": "Function Calls",
    "title": "SynchronySDK.ErrorResponse",
    "category": "Type",
    "text": "Standardized error response for any request. This is returned if any requests fail server-side.\n\n\n\n"
},

{
    "location": "func_ref.html#User-Structures-1",
    "page": "Function Calls",
    "title": "User Structures",
    "category": "section",
    "text": "UserRequest\nUserResponse\nUserConfig\nKafkaConfig\nErrorResponse"
},

{
    "location": "func_ref.html#SynchronySDK.createUser",
    "page": "Function Calls",
    "title": "SynchronySDK.createUser",
    "category": "Function",
    "text": "createUser(config::SynchronyConfig, auth::AuthResponse, user::UserRequest)::UserResponse\n\nCreate a user in Synchrony. Return: Returns the created user.\n\n\n\n"
},

{
    "location": "func_ref.html#SynchronySDK.getUser",
    "page": "Function Calls",
    "title": "SynchronySDK.getUser",
    "category": "Function",
    "text": "getUser(auth::AuthResponse, userId::String)::UserResponse\n\nGets a user given the user ID. Return: The user for the given user ID.\n\n\n\n"
},

{
    "location": "func_ref.html#SynchronySDK.updateUser",
    "page": "Function Calls",
    "title": "SynchronySDK.updateUser",
    "category": "Function",
    "text": "updateUser(auth::AuthResponse, user::User)::UserResponse\n\nUpdate a user. Return: The updated user from the service.\n\n\n\n"
},

{
    "location": "func_ref.html#SynchronySDK.deleteUser",
    "page": "Function Calls",
    "title": "SynchronySDK.deleteUser",
    "category": "Function",
    "text": "deleteUser(auth::AuthResponse, userId::String)::UserResponse\n\nDelete a user given a user ID. Return: The deleted user.\n\n\n\n"
},

{
    "location": "func_ref.html#SynchronySDK.getUserConfig",
    "page": "Function Calls",
    "title": "SynchronySDK.getUserConfig",
    "category": "Function",
    "text": "getUserConfig(auth::AuthResponse, userId::String)::UserConfig\n\nGet a user config given a user ID. The user config contains all the runtime parameters for any robot. Return: The user config.\n\n\n\n"
},

{
    "location": "func_ref.html#User-Functions-1",
    "page": "Function Calls",
    "title": "User Functions",
    "category": "section",
    "text": "createUser\ngetUser\nupdateUser\ndeleteUser\ngetUserConfig"
},

{
    "location": "func_ref.html#Robot-1",
    "page": "Function Calls",
    "title": "Robot",
    "category": "section",
    "text": "Robot calls are used to create, update, retrieve, or delete robots related to users in Synchrony."
},

{
    "location": "func_ref.html#Session-1",
    "page": "Function Calls",
    "title": "Session",
    "category": "section",
    "text": "Session calls are used to ingest or retrieve runtime data from Synchrony. Every running robot saves data against a session, and the Session calls allow a user to retrieve data across all sessions."
},

{
    "location": "func_ref.html#Cyphon-1",
    "page": "Function Calls",
    "title": "Cyphon",
    "category": "section",
    "text": "Cyphon calls allow a user to retrieve more complex data by performing Cypher queries against the saved graph."
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
