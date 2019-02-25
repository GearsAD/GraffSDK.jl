"""
$(SIGNATURES)
Returns a summary list of all landmarks for a given robot and session.
"""
function getLandmarks(robotId::String, sessionId::String)::Vector{NodeResponse}
    landmarkList = filter(n -> occursin(r"[l][0-9]+", n.label), getVariables().nodes)
    return landmarkList
end

"""
$(SIGNATURES)
Returns a summary list of all landmarks for a given robot and session.
"""
function getLandmarks()::Vector{NodeResponse}
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    if config.robotId == "" || config.sessionId == ""
        error("Your config doesn't have a robot or a session specified, please attach your config to a valid robot or session by setting the robotId and sessionId fields. Robot = $(config.robotId), Session = $(config.sessionId)")
    end

    return getLandmarks(config.robotId, config.sessionId)
end

"""
$(SIGNATURES)
BETA method - better if run on the server.
Gets the estimates (if available) for a session or a filtered list if one is provided.
"""
function getEstimates(robotId::String, sessionId::String, nodes::Union{Vector{Union{String, Symbol}}, Vector{NodeResponse}, Nothing}=nothing)::Dict{String, Union{Array{Float64}, Nothing}}
    if nodes == nothing
        # Easy solve
        nodes = getVariables(robotId, sessionId)
        nodes = nodes.nodes
        return Dict(map(n -> n.label, nodes) .=> map(n -> n.mapEst, nodes))
    end
    if typeof(nodes) == Vector{NodeResponse}
        nodes = map(n -> n.label, nodes)
    end
    # Cleaning up if symbols
    nodes = map(n -> String(n), nodes)
    # Now do a getVariables
    respNodes = getVariables(robotId, sessionId).nodes
    respDict = Dict(map(n -> n.label, respNodes) .=> map(n -> n.mapEst, respNodes))
    # And map them - keeping order.
    ests = Dict{String, Union{Array{Any}, Nothing}}()
    for n in nodes
        if haskey(respDict, n)
            ests[n] = respDict[n]
        end
    end
    return ests
end

"""
$(SIGNATURES)
BETA method - better if run on the server.
Gets the estimates (if available) for a session or a filtered list if one is provided.
"""
function getEstimates(nodes::Union{Vector{Union{String, Symbol}}, Vector{NodeResponse}, Nothing}=nothing)::Dict{String, Union{Array{Float64}, Nothing}}
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    if config.robotId == "" || config.sessionId == ""
        error("Your config doesn't have a robot or a session specified, please attach your config to a valid robot or session by setting the robotId and sessionId fields. Robot = $(config.robotId), Session = $(config.sessionId)")
    end

    return getEstimates(config.robotId, config.sessionId, nodes)
end
