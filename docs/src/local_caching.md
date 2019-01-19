# Local Caching

To speed up user experience, GraffSDK can cache data entries locally.

## Important Notes

A few important notes before we continue:
* The current version of the caching assumes the data is immutable, it doesn't check if it was updated in the cloud. If you'd like that feature, please add an issue and we'll include it
* The local cache can be anywhere on a network, so 'local' is actually a misnomer - we recommend somewhere close though (like on a local network)

## Using Local Caching

You will need a version of MongoDB installed, which can be downloaded from [MongoDB Download](https://www.mongodb.com/download-center).

To enable local caching, you then just need to include the [MongoC](https://github.com/felipenoris/Mongoc.jl) library beforehand and then set up the connection:

```julia
using MongoC #Must be done first so GraffSDK recognizes it in the workspace and imports the local cache extensions
using GraffSDK

# Set up a local cache
client = Mongoc.Client("localhost", 27017)
database = client["GraffLocal"]
collection = database["GraffLocal"]
localCache = LocalCache(client, collection)
setLocalCache(localCache)
# Done!

# Strictly optional field - set this to TRUE if you want the data to ONLY exist locally - this isn't recommended but in some instances it's required.
forceOnlyLocalCache(false)
```

Now whenever you retrieve data it will cache it locally:

```julia
# ... Create a factor graph

# Now first call to get data will get it from cloud
GraffSDK.getData(x0, "testId")
# Next calls will retrieve from local cache
GraffSDK.getData(x0, "testId")
```

# Troubleshooting and Notes

* The caching should not throw an exception, all are caught and the message is just shown on the console.
* If you want to see if the cache is used, set your local logger to report DEBUG messages with the following code:
```julia
using Logging
global_logger(ConsoleLogger(stderr, Logging.Debug))
@debug "Debug messages shown!"
# Do Graff operations here...
```
* In normal Graff operation, an exception is thrown if an element doesn't exist. With the caching, it will just return nothing. We'll try fix this in the future, please write an issue if this behavior is causing challenges.
