module TokenHelper
  def read_token(name)
    path = File.expand_path(File.join(File.dirname(__FILE__), '..', 'fixtures', name))
    @token ||= File.read(path)
  end

  def authorize!(name)
    request.headers['Authorization'] = "Bearer #{read_token(name)}"
  end
end

RSpec.configure do |c|
  c.include TokenHelper
end
