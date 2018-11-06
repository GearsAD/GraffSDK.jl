mockConfig = SynchronyConfig("http://mock", "9000", "", "", "")

@testset "User API" begin
    # Arrange
    # NOTE: When you read the body as String(resp.body), it clears (at least in HTTP 0.6.14)
    # So fixing it to not.
    mockResponse = HTTP.Response(200, "{\"id\": \"\",\"name\": \"GearsAD\",\"email\": \"\",\"address\": \"\",\"organization\": \"\",\"licenseType\": \"\",\"billingId\": \"\",\"createdTimestamp\": \"\",\"lastUpdatedTimestamp\": \"\",\"links\": {\"self\": \"https://api.synchronysandbox.com/mocking\"}}")
    mockDuplicate = deepcopy(mockResponse)
    mockDuplicate.body = deepcopy(mockResponse.body)

    mockErrorResponse = HTTP.Response(403)
    mockUserRequest = UserRequest("mockId", "GearsAD", "", "", "", "", "")

    # Generate our mocks for the actual REST calls
    sendRequestMock = @patch _sendRestRequest(synchronyConfig::SynchronyConfig, verbFunction, url::String; data::String="", headers::Dict{String, String}=Dict{String, String}(), debug::Bool=false) = mockResponse
    sendRequestErrorMock = @patch _sendRestRequest(synchronyConfig::SynchronyConfig, verbFunction, url::String; data::String="", headers::Dict{String, String}=Dict{String, String}(), debug::Bool=false) = mockErrorResponse

    # Success criteria
    apply(sendRequestMock) do
        @testset "addUser" begin
            # Act
            callResponse = addUser(mockUserRequest)
            # Assert
            @test callResponse.name == "GearsAD"
        end
        #Making it alive again for testing.
        mockResponse.body = deepcopy(mockDuplicate.body)
        @testset "getUser" begin
            # Act
            callResponse = getUser("GearsAD")
            # Assert
            @test callResponse.name == "GearsAD"
        end
        #Making it alive again for testing.
        mockResponse.body = deepcopy(mockDuplicate.body)
        @testset "updateUser" begin
            # Act
            callResponse = updateUser(mockUserRequest)
            # Assert
            @test callResponse.name == "GearsAD"
        end
        #Making it alive again for testing.
        mockResponse.body = deepcopy(mockDuplicate.body)
        @testset "deleteUser" begin
            # Act
            callResponse = deleteUser("GearsAD")
            # Assert
            @test callResponse.name == "GearsAD"
        end
    end

    # Failure mode
    apply(sendRequestErrorMock) do
        @testset "addUser - Failure Mode" begin
            # Act & Assert
            @test_throws ErrorException addUser(mockUserRequest)
        end
        @testset "getUser - Failure Mode" begin
            # Act & Assert
            @test_throws ErrorException getUser("GearsAD")
        end
        @testset "updateUser - Failure Mode" begin
            # Act & Assert
            @test_throws ErrorException updateUser(mockUserRequest)
        end
        @testset "deleteUser - Failure Mode" begin
            # Act & Assert
            @test_throws ErrorException deleteUser("GearsAD")
        end
    end
end
