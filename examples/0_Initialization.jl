using Base
using JSON, Unmarshal
using SynchronySDK
using SynchronySDK.DataHelpers

# 1. Get a Synchrony configuration
function loadConfig(configFileLocation::String)::SynchronyConfig
    println(" - Retrieving Synchrony Configuration...")
    cd(joinpath(Pkg.dir("SynchronySDK"),"examples"))
    configFile = open(configFileLocation)
    # configFile = open("synchronyConfig_NaviEast_DEV.json")
    configData = JSON.parse(readstring(configFile))
    close(configFile)
    synchronyConfig = Unmarshal.unmarshal(SynchronyConfig, configData)

    println(" --- Configuring Synchrony example for:")
    println("  --- User: $(synchronyConfig.userId)")
    println("  --- Robot: $(robotId)")
    println("  --- Session: $(sessionId)")
    return synchronyConfig
end
