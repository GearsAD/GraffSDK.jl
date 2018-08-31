# Session Service
Session calls are used to ingest or retrieve runtime data from Graff. Every running robot saves data against a session, and the Session calls allow a user to retrieve data across all sessions.

# Interacting with Sessions

## Structures
```@docs
SessionResponse
SessionsResponse
SessionDetailsRequest
SessionDetailsResponse
```

## Functions
```@docs
getSessions
isSessionExisting
getSession
deleteSession
addSession
```

# Getting Graphs - Getting Session Nodes

## Structures
```@docs
NodeResponse
NodesResponse
NodeDetailsResponse
```

## Functions
```@docs
getNodes
getNode
```

# Building Graphs - Adding Nodes/Variables/Factors

## Structures
```@docs
NodeResponse
NodesResponse
NodeDetailsResponse
AddOdometryRequest
AddOdometryResponse
VariableRequest
VariableResponse
DistributionRequest
BearingRangeRequest
FactorBody
FactorRequest
```

## Functions
```@docs
addVariable
addFactor
addBearingRangeFactor
addOdometryMeasurement
putReady
```

# Working with Node Data

## Structures
```@docs
BigDataElementRequest
BigDataEntryResponse
BigDataElementResponse
```

## Functions
```@docs
getDataEntries
getDataElement
getRawDataElement
addDataElement
updateDataElement
addOrUpdateDataElement
deleteDataElement
```
