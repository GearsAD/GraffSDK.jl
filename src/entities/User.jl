mutable struct UserRequest
  id::String
  name::String
  email::String
  address::String
  organization::String
  licenseType::String
  billingId::String
end

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

mutable struct KafkaConfig
    ip::String
    port::String
    inputPoseChannelName::String
    inputImageStreamChannelName::String
    poseUpdateNotificationChannelName::String
end

mutable struct UserConfig
    kafkaConfig::KafkaConfig
end

struct ErrorResponse
    message::String
    returnCode::Int
end
