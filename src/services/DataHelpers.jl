module DataHelpers

using DocStringExtensions


"""
$(SIGNATURES)
Encode data and return the data request.
"""
function encodeJsonData(id::String, description::String, data::Any)::BigDataElementRequest
    return BigDataElementRequest(id, "Mongo", description, JSON.json(data), mimeType="application/json")
end

function encodeBinaryData(id::String, description::String, data::Vector{UInt8}; mimeType="application/octet-stream")
    return BigDataElementRequest(id, "Mongo", description, base64encode(data), mimeType=mimeType)
end

"""
$(SIGNATURES)
Read an image from a file and encode it as a Synchrony data element.
"""
function readImageIntoDataRequest(file::String, id::String, description::String, mimeType)
    try
        fid = open(file,"r")
        imgBytes = read(fid)
        close(fid)
        return BigDataElementRequest(id, "Mongo", description, base64encode(imgBytes), mimeType=mimeType)
    catch ex
        showerror(STDERR, ex)
        error("Unable to read the image from $file - $ex")
    end
end

"""
$(SIGNATURES)
Check if a datastructure is safe for JSON serialization.
"""
function isSafeToJsonSerialize(data::Any)
    try
        JSON.json(data)
        return true
    catch ex
        showerror(STDERR, ex)
        return false
    end
end

end
