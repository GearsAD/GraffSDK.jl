module DataHelpers

using JSON
using GraffSDK
using DocStringExtensions
using Base64


"""
$(SIGNATURES)
Encode data and return the data request.
"""
function encodeJsonData(id::String, description::String, data::Any)::BigDataElementRequest
    return BigDataElementRequest(id, "Mongo", description, Vector{UInt8}(JSON.json(data)), "application/json");
end

function encodeBinaryData(id::String, description::String, data::Vector{UInt8}; mimeType="application/octet-stream")
    return BigDataElementRequest(id, "Mongo", description, data, mimeType);
end

"""
$(SIGNATURES)
Read an image from a file and encode it as a Synchrony data element.
"""
function readFileIntoDataRequest(file::String, id::String, description::String, mimeType)::BigDataElementRequest
    try
        fid = open(file,"r");
        imgBytes = read(fid);
        close(fid);
        return BigDataElementRequest(id, "Mongo", description, imgBytes, mimeType);
    catch ex
        showerror(stderr, ex)
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
        showerror(stderr, ex)
        return false
    end
end

end
