    # import Base: show

"""
The structure used for detailed session requests.
"""
mutable struct SessionDetailsRequest
    id::String
    description::String
    initialPoseType::String
    shouldInitialize::Bool
    SessionDetailsRequest(id::String, description::String, initialPoseType::String="Pose2", shouldInitialize::Bool=true) = new(id, description, initialPoseType, shouldInitialize)
end

"""
The structure used for detailed session responses.
"""
mutable struct SessionDetailsResponse
    sessionId::String
    userId::String
    robotId::String
    environmentIds::Union{Nothing, Vector{String}}
    initialPoseType::String
    nodeCount::Int
    solveCount::Int
    lastSolvedTimestamp::String
    isSolverEnabled::Bool # If 1 then the ad-hoc solver will pick up on it, otherwise will ignore this session.
    shouldInitialize::Bool
    id::String
    description::String
    # lastSolvedResult::Union{Nothing, String}
    # solveTimes::Vector{Any}
    createdTimestamp::String
    lastUpdatedTimestamp::String
    links::Dict{String, Any}
end

function show(io::IO, c::SessionDetailsResponse)
    println(io, "GraffSDK Session:")
    println(io, " - ID: $(c.id)")
    println(io, " - Description: $(c.description)")
    println(io, " - User ID: $(c.userId)")
    println(io, " - Robot ID: $(c.robotId)")
    println(io, " - Environments: $(c.environmentIds != nothing ? c.environmentIds : "")")
    println(io, " - Initial Pose Type: $(c.initialPoseType)")
    println(io, " - Node Count: $(c.nodeCount)")
    println(io, " - Solver Enabled: $(c.isSolverEnabled)")
    println(io, " - Solve Count: $(c.solveCount)")
    println(io, " - Created: $(c.createdTimestamp)")
    println(io, " - Last Solved: $(c.lastSolvedTimestamp)")
    # println(io, " - Last Solved Result: $(c.lastSolvedResult != nothing ? c.lastSolvedResult : "")")
end

"""
A list of session response summaries.
"""
mutable struct SessionsResponse
    sessions::Vector{SessionDetailsResponse}
    links::Dict{String, String}
end

function show(io::IO, c::SessionsResponse)
    println(io, "GraffSDK Sessions (count = $(length(c.sessions))):")
    for s in c.sessions
        print(io, " - $s")
    end
end

"""
The structure used to briefly describe a node in a response.
"""
mutable struct NodeResponse
    id::Int
    label::String
    mapEst::Union{Nothing, Vector{Float64}}
    links::Dict{String, String}
end

function show(io::IO, n::NodeResponse)
    println(io, "GraffSDK Node - ID: $(n.id), label: $(n.label), mapEst: $(n.mapEst != nothing ? n.mapEst : "nothing")")
end

# function show(io::IO, obj::NodeResponse)
#     print("\r\nNode: \r\n - ID: $(obj.id)\r\n  - Name: $(obj.name)")
# end

"""
The structure used to briefly describe a set of nodes in a response.
"""
mutable struct NodesResponse
    nodes::Vector{NodeResponse}
    links::Dict{String, String}
end

function show(io::IO, n::NodesResponse)
    println(io, "GraffSDK Nodes (count = $(length(n.nodes))):")
    for node in n.nodes
        print(io, " - $node")
    end
end

# function show(io::IO, obj::NodesResponse)
#     print("\r\n$(obj.nodes)")
# end

"""
The structure describing a complete node in a response.
"""
mutable struct NodeDetailsResponse
    id::Int
    label::String
    sessionIndex::Int
    type::Union{Nothing, String}
    properties::Dict{String, Any}
    packed::Dict{String, Any}
    labels::Vector{String}
    links::Dict{String, Any}
end

function show(io::IO, n::NodeDetailsResponse)
    println(io, "GraffSDK Node:")
    println(io, " - ID: $(n.id)")
    println(io, " - Label: $(n.label)")
    println(io, " - Graph Labels: $(n.labels)")
end

"""
The structure describing a high-level add-odometry request.
"""
mutable struct AddOdometryRequest
    timestamp::String
    deltaMeasurement::Vector{Float64}
    pOdo::Array{Float64, 2}
    N::Int64
    AddOdometryRequest(deltaMeasurement::Vector{Float64}, pOdo::Array{Float64, 2}, N::Int64) = new(string(now(UTC)), deltaMeasurement, pOdo, N)
    AddOdometryRequest(deltaMeasurement::Vector{Float64}, pOdo::Array{Float64, 2}) = new(string(now(UTC)), deltaMeasurement, pOdo, 100)
end

"""
Result of an AddOdometryRequest - provides the variable and factor details for the created node.
"""
struct AddOdometryResponse
    variable::NodeResponse
    factor::NodeResponse
end

"""
The parameters structure for CreateVariable request.
"""
mutable struct VariableRequest
    label::String
    variableType::String
    N::Int64
    labels::Vector{String}
    VariableRequest(label::String, variableType::String, N::Int64, labels::Vector{String}) = new(label, variableType, N, labels)
    VariableRequest(label::String, variableType::String, labels::Vector{String}) = new(label, variableType, 100, labels)
    VariableRequest(label::String, variableType::String) = new(label, variableType, 100, String[])
end

"""
Result of a CreateVariableRequest.
"""
struct VariableResponse
end

"""
Parameters for a general distribution request - the distribution type and the accompanying parameters.
"""
mutable struct DistributionRequest
    distType::String
    params::Vector{Float64}
end

"""
A 2D bearing+range request body.
"""
mutable struct BearingRangeRequest
    pose2Id::String
    point2Id::String
    bearing::DistributionRequest
    range::DistributionRequest
end

"""
Parameter for a CreateFactor request - the factor type and packed factor details.
"""
mutable struct FactorBody
    factorType::String
    packedFactorType::String
    encoding::String
    body::String
end

"""
The body of a CreateFactor request - the variables to be linked, the body of the factor, and whether it should be autoinitialized and is ready for solving.
"""
mutable struct FactorRequest
    variables::Vector{String}
    body::FactorBody
    autoinit::Bool
    ready::Bool
    FactorRequest(variables::Vector{String}, factorType::String, packedFactor; autoinit::Bool = false, ready::Bool = false ) = begin
        # try
            #TODO: Simplify this
            factBody = FactorBody(factorType, string(typeof(packedFactor)), "application/json", JSON.json(packedFactor))
            return FactorRequest(variables, factBody; autoinit=autoinit, ready=ready)
        # catch ex
        #     error("Unable to serialize the factor body - $ex")
        # end
    end
    FactorRequest(variables::Vector{String}, body::FactorBody; autoinit::Bool = false, ready::Bool = false ) = new(variables, body, autoinit, ready)
end
