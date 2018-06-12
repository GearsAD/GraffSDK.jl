using SynchronySDK
using MeshCat
using CoordinateTransformations
import GeometryTypes: HyperRectangle, Vec, Point, HomogenousMesh, SignedDistanceField, Point3f0
import ColorTypes: RGBA, RGB

# Internal transform functions
function projectPose2(renderObject, node::NodeDetailsResponse)::Void
    mapEst = node.properties["MAP_est"]
    trans = Translation(mapEst[1],mapEst[2],0) ∘ LinearMap(RotZ(mapEst[3]))
    settransform!(renderObject, trans)
    return nothing
end

# Callbacks for pose transforms
poseTransforms = Dict{String, Function}("Pose2" => projectPose2)
# pose2TransFunc = poseTransforms[session.initialPoseType]

"""
$(SIGNATURES)
Visualize a session using MeshCat.
Return: Void.
"""
function visualizeSession(config::SynchronyConfig, robotId::String, sessionId::String, bigDataImageKey::String = "")::Void
    # Create a new visualizer instance
    vis = Visualizer()
    open(vis)

    # Get the session info
    println("Get the session info for session '$sessionId'...")
    sessionInfo = getSession(config, robotId, sessionId)
    println("Looking if we have a pose transform for '$(sessionInfo.initialPoseType)'...")
    if !haskey(poseTransforms, sessionInfo.initialPoseType)
        error("Need an explicit transform for '$(sessionInfo.initialPoseType)' to visualize it. Please edit VisualizationService.jl and add a new PoseTransform.")
    end
    println("Good stuff, using it!")
    pose2TransFunc = poseTransforms[sessionInfo.initialPoseType]

    # Retrieve all variables and render them.
    println("Retrieving all variables and rendering them...")
    nodesResponse = getNodes(config, robotId, sessionId)
    println(" -- Rendering $(length(nodesResponse.nodes)) nodes for session $sessionId for robot $robotId...")
    @showprogress for nSummary in nodesResponse.nodes
        node = getNode(config, robotId, sessionId, nSummary.id)
        label = node.label

        println(" - Rendering $(label)...")
        if haskey(node.properties, "MAP_est")
            mapEst = node.properties["MAP_est"]

            # Parent triad
            triad = Triad(1.0)
            setobject!(vis[label], triad)
            pose2TransFunc(vis[label], node)
        else
            warn("  - Node hasn't been solved, can't really render this one...")
        end
    end
    # Rendering the point clouds and images
    @showprogress for nSummary in nodesResponse.nodes
        node = getNode(config, robotId, sessionId, nSummary.id)
        label = node.label

        println(" - Rendering $(label)...")
        if haskey(node.properties, "MAP_est")
            mapEst = node.properties["MAP_est"]

            # Stochastic point clouds
            if haskey(node.packed, "val")
                println(" - Rendering stochastic measurements")
                # TODO: Make a lookup as well.
                points = map(p -> Point3f0(p[1], p[2], 0), node.packed["val"])
                # Make more fancy in future.
                # cols = reinterpret(RGB{Float32}, points); # use the xyz value as rgb color
                cols = map(p -> RGB{Float32}(1.0, 1.0, 1.0), points)
                # pointsMaterial = PointsMaterial(RGB(1., 1., 1.), 0.001, 2)
                pointCloud = PointCloud(points, cols)
                setobject!(vis[label]["pointCloud"], pointCloud)
            end

            # Camera imagery
            if bigDataImageKey != "" # Get and render big data images and pointclouds
                println(" - Rendering image data for keys that have id = $bigDataImageKey...")
                bigEntries = getDataEntries(config, robotId, sessionId, nSummary.id)
                for bigEntry in bigEntries
                    if bigEntry.id == bigDataImageKey
                        # HyperRectangle until we have sprites
                        box = HyperRectangle(Vec(0,0,0), Vec(0.01, 9.0/16.0/2.0, 16.0/9.0/2.0))
                        dataFrame = getDataElement(config, robotId, sessionId, nSummary.id, bigEntry.id)
                        image = PngImage(base64decode(dataFrame.data))

                        # Make an image and put it in the right place.
                        texture = Texture(image=image)
                        material = MeshBasicMaterial(map=texture)
                        trans = Translation(1.0,16.0/9.0/4.0,0) ∘ LinearMap(RotX(pi/2.0))
                        setobject!(vis[label]["camImage"], box, material)
                        settransform!(vis[label]["camImage"], trans)
                    end
                end
            end
        else
            warn("  - Node hasn't been solved, can't really render this one...")
        end
    end
end
