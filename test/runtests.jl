# Enable mocking
using Mocking
Mocking.enable()

# Standard imports
using Base.Test
using FactCheck
using HTTP

using SynchronySDK

mockConfig = SynchronyConfig("http://mock", "9000", "", "", "")

facts("User API") do
    # Arrange
    mockResponse = HTTP.Response(200, "{\"id\": \"\",\"name\": \"GearsAD\",\"email\": \"\",\"address\": \"\",\"organization\": \"\",\"licenseType\": \"\",\"billingId\": \"\",\"createdTimestamp\": \"\",\"lastUpdatedTimestamp\": \"\",\"links\": {\"self\": \"https://api.synchronysandbox.com/mocking\"}}")
    mockErrorResponse = HTTP.Response(403)
    mockUserRequest = UserRequest("mockId", "GearsAD", "", "", "", "", "")

    # Generate our mocks for the actual REST calls
    sendRequestMock = @patch _sendRestRequest(synchronyConfig::SynchronyConfig, verbFunction, url::String; data::String="", headers::Dict{String, String}=Dict{String, String}(), debug::Bool=false) = mockResponse
    sendRequestErrorMock = @patch _sendRestRequest(synchronyConfig::SynchronyConfig, verbFunction, url::String; data::String="", headers::Dict{String, String}=Dict{String, String}(), debug::Bool=false) = mockErrorResponse

    # Success criteria
    apply(sendRequestMock) do
        context("addUser") do
            # Act
            callResponse = addUser(mockConfig, mockUserRequest)
            # Assert
            @fact callResponse.name --> "GearsAD"
        end
        context("getUser") do
            # Act
            callResponse = getUser(mockConfig, "GearsAD")
            # Assert
            @fact callResponse.name --> "GearsAD"
        end
        context("updateUser") do
            # Act
            callResponse = updateUser(mockConfig, mockUserRequest)
            # Assert
            @fact callResponse.name --> "GearsAD"
        end
        context("deleteUser") do
            # Act
            callResponse = deleteUser(mockConfig, "GearsAD")
            # Assert
            @fact callResponse.name --> "GearsAD"
        end
    end

    # Failure mode
    apply(sendRequestErrorMock) do
        context("addUser - Failure Mode") do
            # Act & Assert
            @fact_throws ErrorException addUser(mockConfig, mockUserRequest)
        end
        context("getUser - Failure Mode") do
            # Act & Assert
            @fact_throws ErrorException getUser(mockConfig, "GearsAD")
        end
        context("updateUser - Failure Mode") do
            # Act & Assert
            @fact_throws ErrorException updateUser(mockConfig, mockUserRequest)
        end
        context("deleteUser - Failure Mode") do
            # Act & Assert
            @fact_throws ErrorException deleteUser(mockConfig, "GearsAD")
        end
    end
end
