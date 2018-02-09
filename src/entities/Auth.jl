mutable struct AuthRequest
  user::String
  apiKey::String
  #TODO
end

mutable struct AuthResponse
  token::String
  refreshToken::String
end
