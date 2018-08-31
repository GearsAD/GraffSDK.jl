# Session Service
Session calls are used to ingest or retrieve runtime data from Synchrony. Every running robot saves data against a session, and the Session calls allow a user to retrieve data across all sessions.

# Session Structures
```@docs
SessionResponse
SessionsResponse
SessionDetailsRequest
SessionDetailsResponse
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

# Session Functions
```@docs
getSessions
isSessionExisting
```
