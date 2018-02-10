"""
The structure used to perform an authentication request.
"""
mutable struct AuthRequest
  user::String
  apiKey::String
  #TODO
end

"""
The structure returned from an authentication call.
"""
mutable struct AuthResponse
  token::String
  refreshToken::String
end
