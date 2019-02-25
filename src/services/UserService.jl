using Mocking

userEndpoint = "api/$curApiVersion/users/{1}"
configEndpoint = "api/$curApiVersion/users/{1}/config"

"""
$(SIGNATURES)
Add a user to Synchrony.
Return: Returns the created user.
"""
function addUser(user::UserRequest)::UserResponse
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
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
function getUser(userId::String)::UserResponse
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    url = "$(config.apiEndpoint)/$(format(userEndpoint, userId))"
    response = @mock _sendRestRequest(config, HTTP.get, url)
    body = String(response.body)
    if(response.status != 200)
        error("Error getting user, received $(response.status) with body '$(body)'.")
    end
    return JSON2.read(body, UserResponse)
end

"""
$(SIGNATURES)
Update a user.
Return: The updated user from the service.
"""
function updateUser(user::UserRequest)::UserResponse
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
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
function deleteUser(userId::String)::UserResponse
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    url = "$(config.apiEndpoint)/$(format(userEndpoint, userId))"
    response = @mock _sendRestRequest(config, HTTP.delete, url)
    if(response.status != 200)
        error("Error deleting user, received $(response.status) with body '$(String(response.body))'.")
    end
    return _unmarshallWithLinks(String(response.body), UserResponse)
end
