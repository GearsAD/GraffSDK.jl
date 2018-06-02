"""
A request for visualization via MeshCat
"""
mutable struct VisualizationRequest
  robotId::String
  sessionId::String

  name::String
  email::String
  address::String
  organization::String
  licenseType::String
  billingId::String
end
