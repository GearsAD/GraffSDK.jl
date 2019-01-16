using Mongoc

"""
The client and collection to use for this local store.
"""
mutable struct LocalStore
  client::Mongoc.Client
  cgBindataCollection #::MongoCollection
end

global __localStores = Dict{String, LocalStore}()
