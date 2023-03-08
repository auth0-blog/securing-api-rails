require 'json_web_token'

class ApplicationController < ActionController::API
  def authorize!
    token = raw_token(request.headers)
    validation_response = JsonWebToken.verify(token)

    @token ||= validation_response.decoded_token

    return unless (error = validation_response.error)

    render json: { message: error.message }, status: error.status
  end

  def can_read_admin_messages!
    check_permissions(@token, 'read:admin-messages')
  end
  
  def check_permissions(token, permission)
    permissions = token['permissions'] || []
    permissions = permissions.split if permissions.is_a? String
  
    unless permissions.include?(permission)
      render json: { message: 'Access is denied' }.to_json,
              status: :unauthorized
    end
  end

  private

  def raw_token(headers)
    return headers['Authorization'].split.last if headers['Authorization'].present?
  end
end
