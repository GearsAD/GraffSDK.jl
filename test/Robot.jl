mockConfig = GraffConfig("http://mock", "9000", "", "", "")
mockConfig.sessionId = "TestSession"
mockConfig.robotId = "TestRobot"

@testset "Robot API" begin
    # Arrange
    mockResponse = HTTP.Response(200, "{\"id\": \"TestSession\",\"description\": \"\",\"robotId\": \"\",\"userId\": \"\",\"initialPoseType\": \"\",\"nodeCount\": 0,\"shouldInitialize\": \"true\",\"createdTimestamp\": \"\",\"lastUpdatedTimestamp\": \"\", \"lastSolvedTimestamp\": \"\", \"isSolverEnabled\": 1, \"links\": {\"self\": \"https://api.synchronysandbox.com/mocking\"}}")
    mockListResponse = HTTP.Response(200, "{\"sessions\": [{\"id\": \"\", \"links\": {\"self\": \"https://api.synchronysandbox.com/mocking\"}}], \"links\": {\"self\": \"https://api.synchronysandbox.com/mocking\"}}")
    mockErrorResponse = HTTP.Response(403)
    mockRequest = SessionDetailsRequest("mockId", "desc", "Pose2", true)
    robotConfig = Dict{String, String}()

    # Generate our mocks for the actual REST calls
    sendRequestMock = @patch _sendRestRequest(synchronyConfig::GraffConfig, verbFunction, url::String; data::String="", headers::Dict{String, String}=Dict{String, String}(), debug::Bool=false) = mockResponse
    sendRequestListMock = @patch _sendRestRequest(synchronyConfig::GraffConfig, verbFunction, url::String; data::String="", headers::Dict{String, String}=Dict{String, String}(), debug::Bool=false) = mockListResponse
    sendRequestErrorMock = @patch _sendRestRequest(synchronyConfig::GraffConfig, verbFunction, url::String; data::String="", headers::Dict{String, String}=Dict{String, String}(), debug::Bool=false) = mockErrorResponse

    sendRequestNodesMock = @patch _sendRestRequest(synchronyConfig::GraffConfig, verbFunction, url::String; data::String="", headers::Dict{String, String}=Dict{String, String}(), debug::Bool=false) = mockResponse

    # Success criteria
    apply(sendRequestListMock) do
        @testset "getSessions" begin
            # Act
            callResponse = getSessions("")
            # Assert
            @test length(callResponse.sessions) == 1
        end
        @testset "isSessionExisting" begin
            # Act
            callResponse = isSessionExisting("", "")
            # Assert
            @test callResponse == true
        end
    end
    apply(sendRequestMock) do
        @testset "getSession" begin
            # Act
            callResponse = getSession("", "")
            # Assert
            @test callResponse.id == "TestSession"
        end
        # @testset "updateSession") do
        #     # Act
        #     callResponse = addSession("", mockRequest)
        #     # Assert
        #     @fact callResponse.name --> "TestRobot"
        # end
        @testset "deleteSession" begin
            # Act & Assert
            callResponse = deleteSession("", "")
        end
        @testset "addSession" begin
            # Act
            callResponse = addSession("", mockRequest)
            # Assert
            @test callResponse.id == "TestSession"
        end
    end

    # apply(sendRequestMock) do
    #     @testset "getNodes") do
    #         # Act
    #         callResponse = getRobotConfig("GearsAD")
    #         # Assert
    #         @fact callResponse["name"] --> "TestRobot"
    #     end
    #     @testset "updateRobotConfig") do
    #         # Act
    #         callResponse = updateRobotConfig("GearsAD", robotConfig)
    #         # Assert
    #         @fact callResponse["name"] --> "TestRobot"
    #     end
    #
    # end

    # Failure mode
    # apply(sendRequestErrorMock) do
    #     @testset "getRobots - Failure Mode") do
    #         # Act & Assert
    #         @fact_throws ErrorException getRobots(    #     end
    #     @testset "getRobot - Failure Mode") do
    #         # Act & Assert
    #         @fact_throws ErrorException getRobot("TestRobot")
    #     end
    #     @testset "addRobot - Failure Mode") do
    #         # Act & Assert
    #         @fact_throws ErrorException addRobot(mockRequest)
    #     end
    #     @testset "deleteRobot - Failure Mode") do
    #         # Act & Assert
    #         @fact_throws ErrorException deleteRobot("GearsAD")
    #     end
    #     @testset "getRobotConfig - Failure Mode") do
    #         # Act & Assert
    #         @fact_throws ErrorException getRobotConfig("GearsAD")
    #     end
    #     @testset "updateRobotConfig - Failure Mode") do
    #         # Act & Assert
    #         @fact_throws ErrorException updateRobotConfig("GearsAD", robotConfig)
    #     end
    # end
end
