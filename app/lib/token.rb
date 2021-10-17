# frozen_string_literal: true

class Token
  AUDIENCE = "public"
  ISSUER = "maitre-d"
  SIGNING_ALG = "RS256"

  def self.secret
    return @secret if defined? @secret

    pem = ENV.fetch( "JWT_RSA_PEM" ) do
      raise ArgumentError, "could not load pem"
    end
    @secret = OpenSSL::PKey::RSA.new pem
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
