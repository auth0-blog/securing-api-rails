require 'rails_helper'

require 'json_web_token'

describe JsonWebToken do
  subject { described_class }

  # rubocop:disable Layout/LineLength
  let(:token) do
    'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6Ik5FTXpRakpEUTBSRk4wUXlNemxETmpVME1VRTFNak00TWpsQ09UWXdNamMzTlVWQk9UUkVSZyJ9.eyJpc3MiOiJodHRwczovL2hjZXJpcy5ldS5hdXRoMC5jb20vIiwic3ViIjoiZ29vZ2xlLW9hdXRoMnwxMTE0NjA0MTk0NTcyODg5MzU3ODciLCJhdWQiOiJzaGVsZjIuaGNlcmlzLmNvbSIsImlhdCI6MTU1NTcxNzM1MywiZXhwIjoxNTU1NzI0NTUzLCJhenAiOiJxMU1Ebmhwa0VDRGJqU2RBOU1Tc2ROUmJYRUtoV0lZaiIsInNjb3BlIjoicHJvZmlsZSBjcmVhdGU6Ym9va3MifQ.HTPZ3ISGdzUYc190vq8rN8lfQKvgg47uIbxGfBmrbJfsQOEg2TQ-oMlTV3j8e486zhlu1NAHh2neIhMmgfJpxuXkMQrnxCwSb_sSHpNU7TNwNY9hnATvU3nslqz-4VW1FwOxtjF38k7uVqZ9Xusm2skH5DR6BPh3lU2T-I79OMVHfQb47vzNBfbCu6xx9cGBzdeJdu9ADHJOnhE8PRp4fpdQ8lDm3hNAMDaKrKXBS49HfxSsEswC5u6WR5FnWm7hCe4CFNBuosMohRkDSGRWGwQcVIAzaQASXMx1NsWpkBSBytlCsQkxYaVK7dV1syXeXqJSCoZKcRHpF-hL50xrOw'
  end

  let(:jwks_raw) do
    # rubocop:disable Style/StringLiterals
    "{\"keys\":[{\"alg\":\"RS256\",\"kty\":\"RSA\",\"use\":\"sig\",\"x5c\":[\"MIIDATCCAemgAwIBAgIJUehs79ahslK3MA0GCSqGSIb3DQEBCwUAMB4xHDAaBgNVBAMTE2hjZXJpcy5ldS5hdXRoMC5jb20wHhcNMTkwNDE2MTkwNzQ3WhcNMzIxMjIzMTkwNzQ3WjAeMRwwGgYDVQQDExNoY2VyaXMuZXUuYXV0aDAuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAso5viNLtITh86OESO6njyqbtf+iPBEcQNmWohKEKMSDTeeWxJP15mWDUPB+EAKTakudsJ/Rs/MiTiEHOJubJ6BVMYyPd/3E9G2fj5KCbHF9140H4UyJfGk9jlYtKZGPJ1QlzxEZ1Krr4LSMO+P/PjD606wPSW6bd9dAUufmYTTJOpNQW/dw0V6meAr1fm1267f5XCJfjMkzQQmFtSpxDN/IpzJgWcjEsQU/0r+KSdzKf7viqotfK9soDuvni292dNzrLDiwMLWth9+6JVi6TMV5uJPfbJInQgOoaRowPWVquavNxXk/hrur4aBdP229jUe9wX+wk5MGV/uzGbEj59QIDAQABo0IwQDAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBS9AsVL15G7Z9uI6p/7I7O7aHaCPDAOBgNVHQ8BAf8EBAMCAoQwDQYJKoZIhvcNAQELBQADggEBALIBpf5Aizfgw2Dge8xJyKELO6kRO0nrBFNyP0viajcRA3jwl9LuV316TjE8eIitmEM0nP4U9AeSkeEPksJBHMak4w+GuE7SkeZ5z6fjpNcZ/1nzJVZMDftjJDNbLeCXO/5bq6ySzYVl53pg5I3auLwEEDcrZKHhRjW0IHxBSqmhYZGajymAaBltHsYS8NP6TfDaT1dXw2EQwgIjxXeoGaQTieX0blGjrJ2y8IRBp1EZ9w2OdHaLEbkD08ndn1m5mQrkX/+F2cSiDZTtrm5Isw1TEJusBbM0j+kEsdwz2VijWIL5K2wjgLMm+tBd5OtibDSoeCNqBW+F/sjtBlMcTq4=\"],\"n\":\"so5viNLtITh86OESO6njyqbtf-iPBEcQNmWohKEKMSDTeeWxJP15mWDUPB-EAKTakudsJ_Rs_MiTiEHOJubJ6BVMYyPd_3E9G2fj5KCbHF9140H4UyJfGk9jlYtKZGPJ1QlzxEZ1Krr4LSMO-P_PjD606wPSW6bd9dAUufmYTTJOpNQW_dw0V6meAr1fm1267f5XCJfjMkzQQmFtSpxDN_IpzJgWcjEsQU_0r-KSdzKf7viqotfK9soDuvni292dNzrLDiwMLWth9-6JVi6TMV5uJPfbJInQgOoaRowPWVquavNxXk_hrur4aBdP229jUe9wX-wk5MGV_uzGbEj59Q\",\"e\":\"AQAB\",\"kid\":\"NEMzQjJDQ0RFN0QyMzlDNjU0MUE1MjM4MjlCOTYwMjc3NUVBOTRERg\",\"x5t\":\"NEMzQjJDQ0RFN0QyMzlDNjU0MUE1MjM4MjlCOTYwMjc3NUVBOTRERg\"}]}"
    # rubocop:enable Style/StringLiterals
  end
  # rubocop:enable Layout/LineLength

  describe '.verify' do
    before do
      allow(Net::HTTP).to receive(:get).and_return(jwks_raw)
    end

    it 'raises exception if the token is incorrect' do
      expect { subject.verify('') }.to raise_exception(JWT::DecodeError)
    end

    it 'raises exception if the token is expired' do
      expect { subject.verify(token) }.to raise_exception(JWT::DecodeError)
    end
  end
end
