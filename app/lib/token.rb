# frozen_string_literal: true

class Token
  ISSUER = "maitre-d"
  SIGNING_ALG = "RS256"
  SIGNING_KEY = "JWT_RSA_PEM"

  def self.secret
    return @secret if defined? @secret

    pem = ENV.fetch( SIGNING_KEY, nil )
    @secret = OpenSSL::PKey::RSA.new pem if pem.present?
  end

  attr_reader :id, :roles

  def initialize( roles: [], id: nil )
    @roles = roles
    @id = id.presence || SecureRandom.uuid
  end

  def to_s
    token
  end

  private

  def token
    headers = { typ: "JWT" }
    JWT.encode body, self.class.secret, SIGNING_ALG, headers
  end

  def body
    {
      aud: "public",
      exp: 1.hour.from_now.to_i,
      iat: Time.now.to_i,
      iss: ISSUER,
      jti: id,
      roles: roles,
    }
  end
end
