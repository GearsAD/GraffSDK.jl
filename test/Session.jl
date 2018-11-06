mockConfig = SynchronyConfig("http://mock", "9000", "", "", "")
mockConfig.sessionId = "TestSession"
mockConfig.robotId = "TestRobot"
setGraffConfig(mockConfig)

@testset "Sessions API" begin
    # Arrange
    mockResponse = HTTP.Response(200, "{\"id\": \"TestSession\",\"description\": \"\",\"robotId\": \"\",\"userId\": \"\",\"initialPoseType\": \"\",\"nodeCount\": 0,\"shouldInitialize\": \"true\",\"createdTimestamp\": \"\",\"lastUpdatedTimestamp\": \"\", \"lastSolvedTimestamp\": \"\", \"isSolverEnabled\": 1, \"links\": {\"self\": \"https://api.synchronysandbox.com/mocking\"}}")
    mockDuplicate = deepcopy(mockResponse)
    mockDuplicate.body = deepcopy(mockResponse.body)

    mockListResponse = HTTP.Response(200, "{\"sessions\": [{\"id\": \"TestSession\", \"links\": {\"self\": \"https://api.synchronysandbox.com/mocking\"}}], \"links\": {\"self\": \"https://api.synchronysandbox.com/mocking\"}}")
    mockListDuplicate = deepcopy(mockListResponse)
    mockListDuplicate.body = deepcopy(mockListResponse.body)

    mockErrorResponse = HTTP.Response(403)
    mockRequest = SessionDetailsRequest("mockId", "desc", "Pose2", true)
    robotConfig = Dict{String, String}()

    # Generate our mocks for the actual REST calls
    sendRequestMock = @patch _sendRestRequest(synchronyConfig::SynchronyConfig, verbFunction, url::String; data::String="", headers::Dict{String, String}=Dict{String, String}(), debug::Bool=false) = mockResponse
    sendRequestListMock = @patch _sendRestRequest(synchronyConfig::SynchronyConfig, verbFunction, url::String; data::String="", headers::Dict{String, String}=Dict{String, String}(), debug::Bool=false) = mockListResponse
    sendRequestErrorMock = @patch _sendRestRequest(synchronyConfig::SynchronyConfig, verbFunction, url::String; data::String="", headers::Dict{String, String}=Dict{String, String}(), debug::Bool=false) = mockErrorResponse

    sendRequestNodesMock = @patch _sendRestRequest(synchronyConfig::SynchronyConfig, verbFunction, url::String; data::String="", headers::Dict{String, String}=Dict{String, String}(), debug::Bool=false) = mockResponse

    # Success criteria
    apply(sendRequestListMock) do
        @testset "getSessions" begin
            # Act
            callResponse = getSessions("TestRobot")
            # Assert
            @test length(callResponse.sessions) == 1
            mockListResponse.body = deepcopy(mockListDuplicate.body)
            # Act
            callResponse = getSessions()
            # Assert
            @test length(callResponse.sessions) == 1
        end
        @testset "isSessionExisting" begin
            mockListResponse.body = deepcopy(mockListDuplicate.body)
            # Act
            callResponse = isSessionExisting("TestRobot", "TestSession")
            # Assert
            @test callResponse == true
            mockListResponse.body = deepcopy(mockListDuplicate.body)
            # Act
            callResponse = isSessionExisting()
            # Assert
            @test callResponse == true
        end
    end
    apply(sendRequestMock) do
        @testset "getSession" begin
            mockResponse.body = deepcopy(mockDuplicate.body)
            # Act
            callResponse = getSession("", "")
            # Assert
            @test callResponse.id == "TestSession"
            mockResponse.body = deepcopy(mockDuplicate.body)
            # Act
            callResponse = getSession()
            # Assert
            @test callResponse.id == "TestSession"
        end
        # @testset "updateSession" begin
        #     # Act
        #     callResponse = addSession("", mockRequest)
        #     # Assert
        #     @test callResponse.name == "TestRobot"
        # end
        @testset "deleteSession" begin
            # Act
            callResponse = deleteSession("", "")
            # Act
            callResponse = deleteSession()
        end
        # @testset "addSession" begin
        #     # Act
        #     callResponse = deleteRobot("", mockRequest)
        #     # Assert
        #     @test callResponse.name == "TestSession"
        #     # Act
        #     callResponse = deleteRobot(mockRequest)
        #     # Assert
        #     @test callResponse.name == "TestSession"
        # end
    end

    apply(sendRequestMock) do
        # @testset "getRobotConfig") do
        #     # Act
        #     callResponse = getRobotConfig("GearsAD")
        #     # Assert
        #     @test callResponse["name"] == "TestRobot"
        # end
        # @testset "updateRobotConfig") do
        #     # Act
        #     callResponse = updateRobotConfig("GearsAD", robotConfig)
        #     # Assert
        #     @test callResponse["name"] == "TestRobot"
        # end

    end
end
