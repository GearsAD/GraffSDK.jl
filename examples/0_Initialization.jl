using Base
using JSON, Unmarshal
using GraffSDK
using GraffSDK.DataHelpers

# 1. Get a Synchrony configuration
function loadConfig(configFileLocation::String)::SynchronyConfig
    println(" - Retrieving GraffSDK Configuration...")
    cd(joinpath(dirname(pathof(GraffSDK)), "..", "examples"))
    configFile = open(configFileLocation)
    # configFile = open("synchronyConfig_NaviEast_DEV.json")
    configData = JSON.parse(read(configFile, String))
    close(configFile)
    synchronyConfig = Unmarshal.unmarshal(SynchronyConfig, configData)

    println(synchronyConfig)
    return synchronyConfig
end
