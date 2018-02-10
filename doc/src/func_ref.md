# SDK Functionality
The Synchrony SDK is split into the following functional groups:
1. Authentication and authorization calls
1. User calls
1. Robot calls
1. Session calls
1. Cyphon calls

# Authentication and Authorization
Authentication and authorization calls are the first step in connecting to Synchrony. The calls are used to create tokens used for subsequent API calls.

## Auth Structures
```@docs
AuthRequest
AuthResponse
```

## Auth Functions
```@docs
authenticate
refreshToken
```

# User
User calls are used to create, update, retrieve, or delete users from Synchrony. It is also used to retrieve runtime configuration information per user (e.g. streaming connection information).

## User Structures
```@docs
UserRequest
UserResponse
UserConfig
KafkaConfig
ErrorResponse
```

## User Functions
```@docs
createUser
getUser
updateUser
deleteUser
getUserConfig
```

# Robot
Robot calls are used to create, update, retrieve, or delete robots related to users in Synchrony.

# Session
Session calls are used to ingest or retrieve runtime data from Synchrony. Every running robot saves data against a session, and the Session calls allow a user to retrieve data across all sessions.

# Cyphon
Cyphon calls allow a user to retrieve more complex data by performing Cypher queries against the saved graph.
