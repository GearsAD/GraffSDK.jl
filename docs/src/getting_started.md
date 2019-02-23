# Getting Started with Graff SDK

This documents the steps for using the SDK, as shown in the examples folder.

This example will walk through the following steps, demonstrating how you can manage, ingest, and extract data for your robots:
1. Loading a Synchrony configuration
1. Getting your user information and runtime configuration
1. Creating a robot that will produce data and ingest it into Synchrony
1. Creating a new robot session
1. Importing data into the new session
1. Running the solver to refine the graph
1. Viewing the results of the SLAM solution

The first step is to create a new script file and import the base libraries:

```julia
using Base
using GraffSDK
```

## Loading a Graff Configuration
The first step in connecting to a Graff system is by loading a configuration.

GraffSDK configurations are loaded by default from `~/.graffsdk.json)` when you call `config = loadGraffConfig()`. There are also other ways of loading configurations:
* If you want to load a different configuration file, please specify with the named parameter `filename`, e.g. `config =loadGraffConfig(filename="./LocalGraffConfig.json")`
* You can also set a local environment variable `graffconfig` with the JSON data (e.g. good for docker images)
* You can ask the user to feed in the parameters in the command-line by specifying a list of variables that should be requested (listed symbols), e.g. `config = loadGraffConfig(;consoleParams=[:userId, :apiEndpoint])`. The remaining parameters will be read by the file

Note that in the configuration file, the robotId and sessionId fields are optional. They are defaults that can be set so you can call convenience methods and don't need to specify the robot and session every time. If you don't have a robot or session set up, no worries! Pick anything you like (no spaces or special characters) and in the later examples this robot and session will be created.

It is assumed that Julia was started in the same folder as the script, so add the following code to the script to load the configuration:

```julia
# 1. Get a Synchrony configuration
# Assume that you're running in local directory
config = loadGraffConfig("synchronyConfig.json")
#Change your session or robot if you like
#config.sessionId = "HexDemoSample1"
println(getGraffConfig())
```

## Checking Credentials and Status of SlamInDb/Graff

There's a quick call to check whether your credentials are working, and whether the services are all working:

```julia
# 1b. Check the credentials and the service status
printStatus()
```

That should show 'UP', otherwise examine the error to figure what is causing it to fail.

## Getting your User
Users maintain the runtime configuration, which is the connection information to ingest data as well as receive notifications when the graph is updated.

Just to confirm our user information, we do the following:

```julia
user = getUser(config.userId)
```

The 'user' variable should contain all our account information. This isn't a necessary step, but helps us check a new user account to make sure all is correct.

## Creating a Robot
Users manage robots, and in this example we have assumed that your user currently has no robots assigned to them. Let's create a robot!

Most of the examples will follow this pattern to create a robot if it doesn't already exist:

```julia
# 2. Confirm that the robot already exists, create if it doesn't.
println(" - Creating or retrieving robot '$(config.robotId)'...")
robot = nothing
if isRobotExisting()
    println(" -- Robot '$(config.robotId)' already exists, retrieving it...")
    robot = getRobot()
else
    # Create a new one programatically - can also do this via the UI.
    println(" -- Robot '$(config.robotId)' doesn't exist, creating it...")
    newRobot = RobotRequest(config.robotId, "My New Bot", "Description of my neat robot", "Active")
    robot = addRobot(newRobot)
end
println(robot)
```

## Creating a New Session

Each robot has a number of sessions - which can be used for solving graphs, multi-session data retrieval, etc. - so you every time you work with data, you will need to be associated to a session.

You can create or retrieve a session using this snippet:

```julia
# 3. Create or retrieve the session.
# Get sessions, if it already exists, add to it.
println(" - Creating or retrieving data session '$(config.sessionId)' for robot...")
session = nothing
if isSessionExisting()
    println(" -- Session '$(config.sessionId)' already exists for robot '$(config.robotId)', retrieving it...")
    session = getSession()
else
    # Create a new one
    println(" -- Session '$(config.sessionId)' doesn't exist for robot '$(config.robotId)', creating it...")
    newSessionRequest = SessionDetailsRequest(config.sessionId, "A test dataset demonstrating data ingestion for a wheeled vehicle driving in a hexagon.", "Pose2")
    session = addSession(newSessionRequest)
end
println(session)
```

## Retrieving Data

You can now retrieve information about this session like this:

```julia
nodes = getNodes();

if length(nodes.nodes) > 0
  @show node = getNode( nodes.nodes[1].id);
end
```

Unless you added data to it earlier, it'll probably just contain a single variable x0. Take a look at some of the examples now to ingest, solve, or examine data!

## Next Steps

There are extensive examples in the [examples folder](./examples/examples.md) that examine use cases of SlamInDb/Graff.
