require 'json_web_token'

class ApplicationController < ActionController::API
  def authorize!
    token = raw_token(request.headers)
    validation_response = JsonWebToken.verify(token)

    @token ||= validation_response.decoded_token

    return unless (error = validation_response.error)

    render json: { message: error.message }, status: error.status
  end

  private

  def raw_token(headers)
    return headers['Authorization'].split.last if headers['Authorization'].present?
  end
end
