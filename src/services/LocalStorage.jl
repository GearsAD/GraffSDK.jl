"""
    $(SIGNATURES)
Set the keyed local store.
"""
function setLocalStore(sourceKey::String, store::LocalStore)::Nothing
    global __localStores
    __localStores[sourceKey] = store
    return nothing
end
"""
    $(SIGNATURES)
Get the keyed local store.
"""
function getLocalStore(sourceKey::String)::Union{Nothing, LocalStore}
    haskey(__localStores, sourceKey) && return __localStores[sourceKey]
    return nothing
end
