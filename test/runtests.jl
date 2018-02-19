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

facts("Auth API") do
    # Arrange
    mockConfig = SynchronyConfig("http://mock", 9000)
    mockResponse = Response(200, "{\"token\":\"MockToken\", \"refreshToken\":\"MockRefresh\"}")
    mockErrorResponse = Response(500)
    mockAuthRequest = AuthRequest("mockUser", "mockApiKey")
    mockAuthResponse = AuthResponse("mockUser", "mockRefresh")
    postMock = @patch post(url::String; data::String="") = mockResponse
    postErrorMock = @patch post(url::String; data::String="") = mockErrorResponse

    # Success criteria
    apply(postMock) do
        context("Getting a token") do
            # Act
            mockToken = authenticate(mockConfig, mockAuthRequest)
            # Assert
            @fact mockToken.token --> "MockToken"
            @fact mockToken.refreshToken --> "MockRefresh"
        end

        context("Refreshing a token") do
            # Act
            mockToken = refreshToken(mockConfig, mockAuthResponse)
            # Assert
            @fact mockToken.token --> "MockToken"
            @fact mockToken.refreshToken --> "MockRefresh"
        end
    end
    apply(postErrorMock) do
        context("Failure mode - Getting a token") do
            # Act & Assert
            @fact_throws ErrorException authenticate(mockConfig, mockAuthRequest)
        end

        context("Failure mode - Refreshing a token") do
            # Act & Assert
            @fact_throws ErrorException refreshToken(mockConfig, mockAuthResponse)
        end
    end
end
