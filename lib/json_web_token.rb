require 'jwt'
require 'net/http'

class JsonWebToken
  class << self
    Error = Struct.new(:message, :status)
    Response = Struct.new(:decoded_token, :error)

    def domain_url
      "https://#{Rails.configuration.auth0.domain}/"
    end

    def verify(token)
      jwks_uri = URI("#{domain_url}.well-known/jwks.json")
      jwks_response = Net::HTTP.get_response jwks_uri

      unless jwks_response.is_a? Net::HTTPSuccess
        error = Error.new('Unable to verify credentials', :internal_server_error)
        return Response.new(nil, error)
      end

      jwks_hash = JSON.parse(jwks_response.body).deep_symbolize_keys

      decoded_token = JWT.decode(token, nil, true, {
                                   algorithm: 'RS256',
                                   iss: domain_url,
                                   verify_iss: true,
                                   aud: Rails.configuration.auth0.audience.to_s,
                                   verify_aud: true,
                                   jwks: { keys: jwks_hash[:keys] }
                                 })
      Response.new(decoded_token, nil)
    rescue JWT::VerificationError, JWT::DecodeError => e
      error = Error.new(e.message, :unauthorized)
      Response.new(nil, error)
    end
  end
end
