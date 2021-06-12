require 'rails_helper'

describe Api::MessagesController, type: :controller do
  describe '#public' do
    subject { get :public, params: { format: :json } }

    it 'returns an accepted answer for the public endpoint' do
      subject

      expect(response).to be_ok

      message = 'The API doesn\'t require an access token to share this message.'
      expect(json_response!).to include('message' => message)
    end
  end

  describe '#protected' do
    subject { get :protected, params: { format: :json } }

    it 'returns an accepted answer for the protected endpoint' do
      authorize! 'validToken'

      subject

      expect(response).to be_ok

      message = 'The API successfully validated your access token.'
      expect(json_response!).to include('message' => message)
    end
  end

  describe '#admin' do
    subject { get :admin, params: { format: :json } }

    it 'returns an accepted answer for the admin endpoint' do
      authorize! 'validWithPermissionsToken'

      subject

      expect(response).to be_ok

      message = 'The API successfully recognized you as an admin.'
      expect(json_response!).to include('message' => message)
    end
  end
end
