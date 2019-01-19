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
$SIGNATURES

    Set to true if GraffSDK should only use local cache.
"""
function forceOnlyLocalCache(isToForce::Bool)::Nothing
    global __forceOnlyLocalCache
    __forceOnlyLocalCache = isToForce
    return nothing
end

"""
$SIGNATURES

    Internal method to get from cache.
"""

function getElement(id::String)::Union{Any, Nothing}
    try
        global __localCache
        if __localCache == nothing
            @debug "Local cache is not set, skipping!"
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
    catch ex
        # Never throw exception if cache fails - just provide error and carry on.
        @error "[GraffSDK] Get cache failed - $ex"
        io = IOBuffer()
        showerror(io, ex, catch_backtrace())
        err = String(take!(io))
        @error "Error! $err"
        return nothing
    end
end

"""
$SIGNATURES

    Internal method to set in cache.
"""
function setElement(id::String, element::BigDataElementResponse)::Nothing
    try
        global __localCache
        if __localCache == nothing
            @debug "Local cache is not set, skipping!"
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
    catch ex
        # Never throw exception if cache fails - just provide error and carry on.
        @error "[GraffSDK] Set cache failed - $ex"
        io = IOBuffer()
        showerror(io, ex, catch_backtrace())
        err = String(take!(io))
        @error "Error! $err"
        return nothing
    end
end

"""
$SIGNATURES

    Internal method to delete from cache.
"""
function deleteElement(id::String)::Nothing
    try
        global __localCache
        if __localCache == nothing
            @debug "Local cache is not set, skipping!"
            return nothing
        end
        selector = Mongoc.BSON("""{ "id": "$(id)" }""")
        numNodes = length(__localCache.collection, selector )
        if numNodes > 0 # exists
            Mongoc.delete_one(__localCache.collection, selector)
        end
        return nothing
    catch ex
        # Never throw exception if cache fails - just provide error and carry on.
        @error "[GraffSDK] Delete cache failed - $ex"
        io = IOBuffer()
        showerror(io, ex, catch_backtrace())
        err = String(take!(io))
        @error "Error! $err"
        return nothing
    end
end
