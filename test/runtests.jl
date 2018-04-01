# Enable mocking
using Mocking
Mocking.enable(force=true)

# Standard imports
using Base.Test
using FactCheck
using Requests, HttpCommon
using SynchronySDK

# TESTING
test = "{\"id\":\"NewUser\",\"name\":\"Bob Zacowski\",\"email\":\"email@email.com\",\"address\":\"N/A\",\"organization\":\"Student\",\"licenseType\":\"Student\",\"billingId\":\"96a3877e-738d-4c92-a880-98b0cbfd8937\",\"createdTimestamp\":\"2018-02-10T09:26:01.328\",\"lastUpdatedTimestamp\":\"2018-02-10T09:26:01.328\",\"links\":{\"robots\":\"/api/v0/users/NewUser/robots\",\"config\":\"/api/v0/users/NewUser/config\",\"self\":\"/api/v0/users/NewUser\"}}"
j = JSON.parse(test)
user = _unmarshallWithLinks(test, UserResponse)
@test JSON.json(user) == JSON.json(user)

mockConfig = SynchronyConfig("http://mock", 9000, "", "", "")


facts("User API") do
    # Arrange
    mockResponse = Response(200, "{\"id\": \"\",\"name\": \"GearsAD\",\"email\": \"\",\"address\": \"\",\"organization\": \"\",\"licenseType\": \"\",\"billingId\": \"\",\"createdTimestamp\": \"\",\"lastUpdatedTimestamp\": \"\",\"links\": {\"self\": \"https://api.synchronysandbox.com/mocking\"}}")
    mockErrorResponse = Response(500)
    mockUserRequest = UserRequest("mockId", "GearsAD", "", "", "", "", "")

    # Generate our mocks for the actual REST calls
    postMock = @patch post(url::String; headers=Dict{Any,Any}(), data::String="") = mockResponse
    getMock = @patch get(url::String; headers=Dict{Any,Any}()) = mockResponse
    putMock = @patch put(url::String; headers=Dict{Any,Any}(), data::String="") = mockResponse
    deleteMock = @patch delete(url::String; headers=Dict{Any,Any}(), data::String="") = mockResponse
    postErrorMock = @patch post(url::String; headers=Dict{Any,Any}(), data::String="") = mockErrorResponse

    # Success criteria
    apply(postMock) do
        context("createUser") do
            # Act
            callResponse = createUser(mockConfig, mockUserRequest)
            # Assert
            @fact callResponse.name --> "GearsAD"
        end
    end
    apply(getMock) do
        context("getUser") do
            # Act
            callResponse = getUser(mockConfig, "GearsAD")
            # Assert
            @fact callResponse.name --> "GearsAD"
        end
    end
    apply(putMock) do
        context("getUser") do
            # Act
            callResponse = updateUser(mockConfig, mockUserRequest)
            # Assert
            @fact callResponse.name --> "GearsAD"
        end
    end
    apply(deleteMock) do
        context("deleteUser") do
            # Act
            callResponse = deleteUser(mockConfig, "GearsAD")
            # Assert
            @fact callResponse.name --> "GearsAD"
        end
    end
#        updateUser
#        deleteUser
#        getUserConfig
    # apply(postErrorMock) do
    #     context("Failure mode - Getting a token") do
    #         # Act & Assert
    #         @fact_throws ErrorException authenticate(mockConfig, mockAuthRequest)
    #     end
    #
    #     context("Failure mode - Refreshing a token") do
    #         # Act & Assert
    #         @fact_throws ErrorException refreshToken(mockConfig, mockAuthResponse)
    #     end
    # end
end
