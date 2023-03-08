module TokenHelper
  def authorize!(name)
    request.headers['Authorization'] = "Bearer #{read_token(name)}"
    can_authenticate
  end

  def can_authenticate
    allow(JsonWebToken).to receive(:algorithm).and_return('HS256')
    allow(JsonWebToken).to receive(:key).and_return('changeme')
  end

  private

  def read_token(name)
    path = File.expand_path(File.join(File.dirname(__FILE__), '..', 'fixtures', name))
    @token ||= File.read(path)
  end
end

RSpec.configure do |c|
  c.include TokenHelper
end
