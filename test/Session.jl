mockConfig = SynchronyConfig("http://mock", "9000", "", "", "")

facts("Sessions API") do
    # Arrange
    mockResponse = HTTP.Response(200, "{\"id\": \"TestSession\",\"description\": \"\",\"robotId\": \"\",\"userId\": \"\",\"initialPoseType\": \"\",\"nodeCount\": 0,\"shouldInitialize\": \"true\",\"createdTimestamp\": \"\",\"lastUpdatedTimestamp\": \"\", \"lastSolvedTimestamp\": \"\", \"isSolverEnabled\": 1, \"links\": {\"self\": \"https://api.synchronysandbox.com/mocking\"}}")
    mockListResponse = HTTP.Response(200, "{\"sessions\": [{\"id\": \"\", \"links\": {\"self\": \"https://api.synchronysandbox.com/mocking\"}}], \"links\": {\"self\": \"https://api.synchronysandbox.com/mocking\"}}")
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
        context("getSessions") do
            # Act
            callResponse = getSessions(mockConfig, "")
            # Assert
            @fact length(callResponse.sessions) --> 1
        end
        context("isSessionExisting") do
            # Act
            callResponse = isSessionExisting(mockConfig, "", "")
            # Assert
            @fact callResponse --> true
        end
    end
    apply(sendRequestMock) do
        context("getSession") do
            # Act
            callResponse = getSession(mockConfig, "", "")
            # Assert
            @fact callResponse.id --> "TestSession"
        end
        # context("updateSession") do
        #     # Act
        #     callResponse = addSession(mockConfig, "", mockRequest)
        #     # Assert
        #     @fact callResponse.name --> "TestRobot"
        # end
        context("deleteSession") do
            # Act & Assert
            callResponse = deleteSession(mockConfig, "", "")
        end
        # context("addSession") do
        #     # Act
        #     callResponse = deleteRobot(mockConfig, "", mockRequest)
        #     # Assert
        #     @fact callResponse.name --> "TestSession"
        # end
    end

    # apply(sendRequestMock) do
    #     context("getNodes") do
    #         # Act
    #         callResponse = getRobotConfig(mockConfig, "GearsAD")
    #         # Assert
    #         @fact callResponse["name"] --> "TestRobot"
    #     end
    #     context("updateRobotConfig") do
    #         # Act
    #         callResponse = updateRobotConfig(mockConfig, "GearsAD", robotConfig)
    #         # Assert
    #         @fact callResponse["name"] --> "TestRobot"
    #     end
    #
    # end

    # Failure mode
    # apply(sendRequestErrorMock) do
    #     context("getRobots - Failure Mode") do
    #         # Act & Assert
    #         @fact_throws ErrorException getRobots(mockConfig)
    #     end
    #     context("getRobot - Failure Mode") do
    #         # Act & Assert
    #         @fact_throws ErrorException getRobot(mockConfig, "TestRobot")
    #     end
    #     context("addRobot - Failure Mode") do
    #         # Act & Assert
    #         @fact_throws ErrorException addRobot(mockConfig, mockRequest)
    #     end
    #     context("deleteRobot - Failure Mode") do
    #         # Act & Assert
    #         @fact_throws ErrorException deleteRobot(mockConfig, "GearsAD")
    #     end
    #     context("getRobotConfig - Failure Mode") do
    #         # Act & Assert
    #         @fact_throws ErrorException getRobotConfig(mockConfig, "GearsAD")
    #     end
    #     context("updateRobotConfig - Failure Mode") do
    #         # Act & Assert
    #         @fact_throws ErrorException updateRobotConfig(mockConfig, "GearsAD", robotConfig)
    #     end
    # end
end
