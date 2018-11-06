# Enable mocking
using Mocking
Mocking.enable()

# Standard imports
using Test
using HTTP

using GraffSDK

mockConfig = SynchronyConfig("http://mock", "9000", "QAUSER", "QAROBOT", "QASESSION")
setGraffConfig(mockConfig)

include("User.jl")
include("Session.jl")
