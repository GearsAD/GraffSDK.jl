"""
$(SIGNATURES)
Returns a summary list of all landmarks for a given robot and session.
"""
function getLandmarks(robotId::String, sessionId::String)::Vector{NodeResponse}
    landmarkList = filter(n -> occursin(r"[l][0-9]+", n.label), getNodes().nodes)
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

    return getSessionLandmarks(config.robotId, config.sessionId)
end

"""
$(SIGNATURES)
BETA method - better if run on the server.
Gets the estimates (if available) for a session or a filtered list if one is provided.
"""
function getEstimates(robotId::String, sessionId::String; nodes::Union{Vector{Union{String, Symbol}}, Vector{NodeResponse}, Nothing}=nothing)::Dict{String, Union{Array{Any}, Nothing}}
    if nodes == nothing
        nodes = getNodes(robotId, sessionId)
        nodes = nodes.nodes
    end
    if typeof(nodes) == Vector{NodeResponse}
        nodes = map(n -> n.label, nodes)
    end
    # Cleaning up if symbols
    nodes = map(n -> String(n), nodes)
    @info "[getEstimates] Have $(length(nodes)) nodes to retrieve estimates, getting the values..."
    # Getting estimates
    ests = Dict{String, Union{Array{Any}, Nothing}}()
    for n in nodes
        nResp = getNode(robotId, sessionId, n)
        push!(ests, n => (haskey(nResp.properties, "MAP_est") ? nResp.properties["MAP_est"] : nothing))
    end
    return ests
end

"""
$(SIGNATURES)
BETA method - better if run on the server.
Gets the estimates (if available) for a session or a filtered list if one is provided.
"""
function getEstimates(; nodes::Union{Vector{Union{String, Symbol}}, Vector{NodeResponse}, Nothing}=nothing)::Dict{String, Union{Array{Any}, Nothing}}
    config = getGraffConfig()
    if config == nothing
        error("Graff config is not set, please call setGraffConfig with a valid configuration.")
    end
    if config.robotId == "" || config.sessionId == ""
        error("Your config doesn't have a robot or a session specified, please attach your config to a valid robot or session by setting the robotId and sessionId fields. Robot = $(config.robotId), Session = $(config.sessionId)")
    end

    return getEstimates(config.robotId, config.sessionId; nodes=nodes)
end
