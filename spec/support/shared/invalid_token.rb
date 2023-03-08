RSpec.shared_examples 'invalid token' do |message|
  it message.to_s do
    error_struct = double(message: message, status: :unauthorized)
    response_struct = double(decoded_token: nil, error: error_struct)
    allow(JsonWebToken).to receive(:verify).and_return(response_struct)

    subject

    expect(response).to be_unauthorized
    expect(json_response!).to include('message' => message)
  end
end
