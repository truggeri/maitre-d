# frozen_string_literal: true

class Token
  AUDIENCE = "public"
  ISSUER = "maitre-d"
  SIGNING_ALG = "RS256"

  def self.secret
    pem = ENV[ "JWT_RSA_PEM" ]
    return OpenSSL::PKey::RSA.new pem if pem.present?

    raise ArgumentError, "pem nout found"
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
    time = Time.now.utc
    {
      aud: AUDIENCE,
      exp: ( time + 1.hour ).to_i,
      iat: time.to_i,
      iss: ISSUER,
      jti: id,
      roles: roles,
    }
  end
end
