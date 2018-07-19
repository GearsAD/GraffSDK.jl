# Enable mocking
using Mocking
Mocking.enable()

# Standard imports
using Base.Test
using FactCheck
using HTTP

using SynchronySDK

include("User.jl")
include("Robot.jl")
