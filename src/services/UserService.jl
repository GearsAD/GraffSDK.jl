include("../entities/Visualization.jl")
using Mocking

userEndpoint = "api/v0/users/{1}"
configEndpoint = "api/v0/users/{1}/config"

"""
$(SIGNATURES)
Add a user to Synchrony.
Return: Returns the created user.
"""
function addUser(config::SynchronyConfig, user::UserRequest)::UserResponse
    url = "$(config.apiEndpoint)/$(format(userEndpoint, user.id))"
    response = @mock _sendRestRequest(config, post, url, data=JSON.json(user), debug=true)
    if(statuscode(response) != 200)
        error("Error creating user, received $(statuscode(response)) with body '$(readstring(response))'.")
    end
    return _unmarshallWithLinks(readstring(response), UserResponse)
end

"""
$(SIGNATURES)
Gets a user given the user ID.
Return: The user for the given user ID.
"""
function getUser(config::SynchronyConfig, userId::String)::UserResponse
    url = "$(config.apiEndpoint)/$(format(userEndpoint, userId))"
    response = @mock _sendRestRequest(config, get, url)
    if(statuscode(response) != 200)
        error("Error getting user, received $(statuscode(response)) with body '$(readstring(response))'.")
    end
    return _unmarshallWithLinks(readstring(response), UserResponse)
end

"""
$(SIGNATURES)
Update a user.
Return: The updated user from the service.
"""
function updateUser(config::SynchronyConfig, user::UserRequest)::UserResponse
    url = "$(config.apiEndpoint)/$(format(userEndpoint, user.id))"
    response = @mock _sendRestRequest(config, put, url, data=JSON.json(user))
    if(statuscode(response) != 200)
        error("Error updating user, received $(statuscode(response)) with body '$(readstring(response))'.")
    end
    return _unmarshallWithLinks(readstring(response), UserResponse)
end

"""
$(SIGNATURES)
Delete a user given a user ID.
NOTE: All robots must be deleted first, the call will fail if robots are still associated to the user.
Return: The deleted user.
"""
function deleteUser(config::SynchronyConfig, userId::String)::UserResponse
    url = "$(config.apiEndpoint)/$(format(userEndpoint, userId))"
    response = @mock _sendRestRequest(config, delete, url)
    if(statuscode(response) != 200)
        error("Error deleting user, received $(statuscode(response)) with body '$(readstring(response))'.")
    end
    return _unmarshallWithLinks(readstring(response), UserResponse)
end

"""
$(SIGNATURES)
Get a user config given a user ID.
The user config contains all the runtime parameters for any robot.
Return: The user config.
"""
function getUserConfig(config::SynchronyConfig, userId::String)::UserConfig
    url = "$(config.apiEndpoint)/$(format(configEndpoint, userId))"
    response = @mock _sendRestRequest(config, get, url)
    if(statuscode(response) != 200)
        error("Error getting user configuration, received $(statuscode(response)) with body '$(readstring(response))'.")
    end
    return Unmarshal.unmarshal(UserConfig, JSON.parse(readstring(response)))
end
