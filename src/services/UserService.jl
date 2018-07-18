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
    response = @mock _sendRestRequest(config, HTTP.post, url, data=JSON.json(user), debug=true)
    if(response.status != 200)
        error("Error creating user, received $(response.status) with body '$(String(response.body))'.")
    end
    return _unmarshallWithLinks(String(response.body), UserResponse)
end

"""
$(SIGNATURES)
Gets a user given the user ID.
Return: The user for the given user ID.
"""
function getUser(config::SynchronyConfig, userId::String)::UserResponse
    url = "$(config.apiEndpoint)/$(format(userEndpoint, userId))"
    response = @mock _sendRestRequest(config, HTTP.get, url)
    if(response.status != 200)
        error("Error getting user, received $(response.status) with body '$(String(response.body))'.")
    end
    return _unmarshallWithLinks(String(response.body), UserResponse)
end

"""
$(SIGNATURES)
Update a user.
Return: The updated user from the service.
"""
function updateUser(config::SynchronyConfig, user::UserRequest)::UserResponse
    url = "$(config.apiEndpoint)/$(format(userEndpoint, user.id))"
    response = @mock _sendRestRequest(config, HTTP.put, url, data=JSON.json(user))
    if(response.status != 200)
        error("Error updating user, received $(response.status) with body '$(String(response.body))'.")
    end
    return _unmarshallWithLinks(String(response.body), UserResponse)
end

"""
$(SIGNATURES)
Delete a user given a user ID.
NOTE: All robots must be deleted first, the call will fail if robots are still associated to the user.
Return: The deleted user.
"""
function deleteUser(config::SynchronyConfig, userId::String)::UserResponse
    url = "$(config.apiEndpoint)/$(format(userEndpoint, userId))"
    response = @mock _sendRestRequest(config, HTTP.delete, url)
    if(response.status != 200)
        error("Error deleting user, received $(response.status) with body '$(String(response.body))'.")
    end
    return _unmarshallWithLinks(String(response.body), UserResponse)
end
