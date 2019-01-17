"""
    $(SIGNATURES)
Set the local cache.
"""
function setLocalCache(cache::Union{LocalCache, Nothing})::Nothing
    global __localCache
    __localCache = cache
    return nothing
end
"""
    $(SIGNATURES)
Get the keyed local cache.
"""
function getLocalCache()::Union{Nothing, LocalCache}
    global __localCache
    return __localCache
end

"""
Set to true if GraffSDK should only use local cache.
"""
function forceOnlyLocalCache(isToForce::Bool)::Nothing
    global __forceOnlyLocalCache
    __forceOnlyLocalCache = isToForce
    return nothing
end

function getElement(id::String)::Union{Any, Nothing}
    global __localCache
    if __localCache == nothing
        @info "Local cache is not set, skipping!"
        return nothing
    end
    numNodes = length(__localCache.collection, Mongoc.BSON("""{ "id": "$(id)" }""") )
    numNodes == 0 && return nothing
    result = Mongoc.find_one(__localCache.collection, Mongoc.BSON("""{ "id": "$(id)" }""") )
    if(typeof(result) == Mongoc.BSON)
        dict = Mongoc.as_dict(result)
        return JSON2.read(dict["data"], BigDataElementResponse)
    else
        @show result
        return JSON2.read(result["data"], BigDataElementResponse)
    end
end

function setElement(id::String, element::BigDataElementResponse)::Nothing
    global __localCache
    if __localCache == nothing
        @info "Local cache is not set, skipping!"
        return nothing
    end
    selector = Mongoc.BSON("""{ "id": "$(id)" }""")
    numNodes = length(__localCache.collection, selector )
    bsonDoc = Mongoc.BSON()
    bsonDoc["id"] = id
    bsonDoc["data"] = JSON2.write(element)
    if numNodes > 0 # exists
        # Set wrapper...
        setDoc = Mongoc.BSON()
        setDoc["\$set"] = bsonDoc
        Mongoc.update_one(__localCache.collection, selector, setDoc)
    else
        push!(__localCache.collection, bsonDoc)
    end
    return nothing
end

export getElement, setElement
