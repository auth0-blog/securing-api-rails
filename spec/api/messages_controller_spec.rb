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

    it 'returns error for the protected endpoint if there is no token' do
      can_authenticate

      subject

      expect(response).to be_unauthorized

      message = 'Nil JSON web token'
      expect(json_response!).to include('message' => message)
    end

    it 'returns error for the protected endpoint if the token is expired' do
      authorize! 'expiredToken'

      subject

      expect(response).to be_unauthorized
      expect(json_response!['message']).to include('Signature has expired')
    end

    it 'returns error for the protected endpoint if the token has the wrong issuer' do
      authorize! 'wrongIssuerToken'

      subject

      expect(response).to be_unauthorized
      expect(json_response!['message']).to include('Invalid issuer')
    end

    it 'returns error for the protected endpoint if the token has the wrong audience' do
      authorize! 'wrongAudienceToken'

      subject

      expect(response).to be_unauthorized
      expect(json_response!['message']).to include('Invalid audience')
    end

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
