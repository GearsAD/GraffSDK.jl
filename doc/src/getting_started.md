# Getting Started with Synchrony SDK

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
using SynchronySDK
```

## Loading a Synchrony Configuration
In the same location as the new script, create a file called 'synchronyConfig.json', and paste in your Synchrony endpoint which was provided when you created your account:
```json
{
  "apiEndpoint":"http://myserver...",
  "apiPort":8000
}
```

It is assumed that Julia was started in the same folder as the script, so add the following code to the script to load the configuration:

```julia
# 1. Get a Synchrony configuration
# Assume that you're running in local directory
configFile = open("synchronyConfig.json")
configData = JSON.parse(readstring(configFile))
close(configFile)
synchronyConfig = Unmarshal.unmarshal(SynchronyConfig, configData)
```

## Creating a Token
Next step is to create a token for your user. Add the following code with your user and API key:

```julia
# 2. Authorizing ourselves for requests
authRequest = AuthRequest("user", "apiKey")
auth = authenticate(synchronyConfig, authRequest)
```

This will fire off an authentication request, and return an AuthRespose that contains a token.

## Getting your User and Runtime Configuration Information
Users maintain the runtime configuration, which is the connection information to ingest data as well as receive notifications when the graph is updated.

Just to confirm our user information, we do the following:

```julia
userId = "myUserId" #TODO: Replace with your user ID
user = getUser(synchronyConfig, auth, myUserId)
```

The 'user' variable should contain all our account information. This isn't a necessary step, but helps us check a new user account to make sure all is correct.

We do need to get the runtime information to subscribe to notifications and ingest data though, so let's retrieve the runtime configuration for this user:

```julia
# 3. Config retrieval
# This contains all the parameters required to ingest or retrieve
# data from the system.
runtimeConfig = getUserConfig(synchronyConfig, auth, userId)
```

We can now use the runtime configuration to ingest data for a given robot as well as subscribe for graph updates. Firstly though, we need to create robot and a new session for the data.

## Creating a Robot
Users manage robots, and in this example we have assumed that your user currently has no robots assigned to them. Let's create a robot!

TODO

## Creating a New Session

## Importing Data into the New Session

TODO
