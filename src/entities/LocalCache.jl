using .Mongoc

"""
The client and collection to use for this local cache.
"""
mutable struct LocalCache
  client::Mongoc.Client
  collection #::MongoCollection
end

global __localCache = nothing

global __forceOnlyLocalCache = false
