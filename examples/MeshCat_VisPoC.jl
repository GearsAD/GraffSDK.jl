using SynchronySDK
using MeshCat
using CoordinateTransformations
import GeometryTypes: HyperRectangle, Vec, Point, HomogenousMesh, SignedDistanceField
import ColorTypes: RGBA, RGB

cd(joinpath(Pkg.dir("SynchronySDK"),"examples"))
include("0_Initialization.jl")

function projectPose2(renderObject, node::NodeDetailsResponse)::Void
    mapEst = node.properties["MAP_est"]
    trans = Translation(mapEst[1],mapEst[2],0) ∘ LinearMap(RotZ(mapEst[3]))
    settransform!(renderObject, trans)
    return nothing
end

# Callbacks for pose transforms
poseTransforms = Dict{String, Function}("Pose2" => projectPose2)

# Get the session to determine how we render the variables...
session = getSession(synchronyConfig, robotId, sessionId)
pose2TransFunc = poseTransforms[session.initialPoseType]

# Create a new visualizer instance
vis = Visualizer()
open(vis)

# Retrieve all variables and render them.
println("Retrieving all variables and rendering them...")
nodesResponse = getNodes(synchronyConfig, robotId, sessionId)
println(" -- Rendering $(length(nodesResponse.nodes)) nodes for session $sessionId for robot $robotId...")

for nSummary in nodesResponse.nodes
    node = getNode(synchronyConfig, robotId, sessionId, nSummary.id)
    label = node.label

    println(" - Rendering $(label)...")
    if haskey(node.properties, "MAP_est")
        mapEst = node.properties["MAP_est"]

        # Parent triad
        triad = Triad(2.5)
        setobject!(vis[label], triad)
        pose2TransFunc(vis[label], node)

        # Stochastic point clouds
        if haskey(node.packed, "val")
            println(" - Rendering pointcloud")
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
        # HyperRectangle until we have sprites
        box = HyperRectangle(Vec(0,0,0), Vec(0.01, 9.0/16.0, 16.0/9.0))
        image = PngImage(joinpath(Pkg.dir("SynchronySDK"), "examples", "pexels-photo-1004665.png"))
        texture = Texture(image=image)
        material = MeshBasicMaterial(map=texture)
        trans = Translation(1.0,16.0/9.0/2.0,0) ∘ LinearMap(RotX(pi/2.0))
        setobject!(vis[label]["camImage"], box, material)
        settransform!(vis[label]["camImage"], trans)

        # Connectivity
        # TODO, need adjacency matrix for session.
    else
        warn("  - Node hasn't been solved, can't really render this one...")
    end
end
