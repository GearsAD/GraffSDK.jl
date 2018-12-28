# Enable mocking
using Mocking
Mocking.enable()

# Standard imports
using Test
using HTTP

include("EndToEnd.jl")
