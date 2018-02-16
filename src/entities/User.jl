"""
The structure used for user requests.
"""
mutable struct UserRequest
  id::String
  name::String
  email::String
  address::String
  organization::String
  licenseType::String
  billingId::String
end

"""
The response structure for user calls.
"""
mutable struct UserResponse
  id::String
  name::String
  email::String
  address::String
  organization::String
  licenseType::String
  billingId::String
  createdTimestamp::String
  lastUpdatedTimestamp::String
  links::Dict{String, String}
end

"""
Runtime configuration parameters for connecting to the streaming API.
"""
mutable struct KafkaConfig
    ip::String
    port::String
    inputPoseChannelName::String
    inputImageStreamChannelName::String
    poseUpdateNotificationChannelName::String
end

"""
Runtime configuration parameters for connecting to the Synchrony API.
"""
mutable struct UserConfig
    kafkaConfig::KafkaConfig
end
