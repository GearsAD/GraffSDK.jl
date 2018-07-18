using ImageView, ImageMagick
using Images, ImageDraw, TestImages
using LCMCore, CaesarLCMTypes
using JSON
using SynchronySDK

function lcm_ShowData(channel, msg::brookstone_supertype_t, images::Vector{BigDataElementRequest})
    img = msg.img
    dataElementRequest = BigDataElementRequest("CamImage", "Mongo", "Brookstone camera data", base64encode(img.data), "image/jpeg")
    push!(images, dataElementRequest)
end

# Get the imagery from the LCM log
# TODO: Get it from the DB when we have access
cd(Pkg.dir("SynchronySDK"))
lcm = LCMLog("examples/data/brookstone_3.lcmlog")
images = Vector{BigDataElementRequest}()
subscribe(lcm, "BROOKSTONE_ROVER", (c,m)->lcm_ShowData(c,m, images), brookstone_supertype_t)
while handle(lcm)
end

# Let's run an AprilTags detector on the sequence.
using AprilTags
# Simple method to show the image with the tags
function showImage(image, tags, canvas)
    # Convert image to RGB
    imageCol = RGB.(image)
    #draw color box on tag corners
    if tags != nothing && length(tags) != 0
        foreach(tag->drawTagBox!(imageCol, tag, 4), tags)
    end
    imshow(canvas["gui"]["canvas"], imageCol)
    sleep(tags != nothing  && length(tags) != 0 ? 1 : 0.03)
    return nothing
end

canvas = imshow(load(Pkg.dir("SynchronySDK") * "/examples/pexels_small.png"))
sleep(2)
detector = AprilTagDetector()
for imageBlob in images
    imData = base64decode(imageBlob.data)
    image = readblob(imData)
    tags = detector(image)
    @show tags
    showImage(image, tags, canvas)
end
# Close the images
ImageView.closeall()
# Free the detector
freeDetector!(detector)

# TODO - add in the bearing+range data.
# https://github.com/JuliaRobotics/AprilTags.jl/blob/master/test/runtests.jl#L73
# https://github.com/JuliaRobotics/Caesar.jl/blob/example/apriltagvisualizer/examples/apriltagserver/tag_exporter.jl
# https://github.com/JuliaRobotics/Caesar.jl/blob/example/apriltagvisualizer/examples/apriltagserver/tag2slam.jl#L29
