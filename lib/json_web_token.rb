require 'jwt'
require 'net/http'

class JsonWebToken
  class << self
    def verify(token)
      JWT.decode(token, nil,
                 true, # Verify the signature of this token
                 algorithm: 'RS256',
                 iss: Rails.application.config.x.auth0.issuerUri,
                 verify_iss: true,
                 aud: Rails.application.config.x.auth0.audience,
                 verify_aud: true) do |header|
        jwks_hash[header['kid']]
      end
    end

    def jwks_hash
      issuer = Rails.application.config.x.auth0.issuerUri
      jwks_raw = Net::HTTP.get URI("#{issuer}/.well-known/jwks.json")
      jwks_keys = Array(JSON.parse(jwks_raw)['keys'])
      jwks_keys.map do |k|
        [
          k['kid'],
          OpenSSL::X509::Certificate.new(Base64.decode64(k['x5c'].first)).public_key
        ]
      end.to_h
    end
  end
end
