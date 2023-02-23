module Api
  class MessagesController < ApplicationController
    before_action :authorize!, except: %i[public]
    before_action :can_read_admin_messages!, only: %i[admin]
    
    def public
      message = 'The API doesn\'t require an access token to share this message.'
      render json: { message: message }
    end

    def protected
      message = 'The API successfully validated your access token.'
      render json: { message: message }
    end

    def admin
      message = 'The API successfully recognized you as an admin.'
      render json: { message: message }
    end
  end
end
