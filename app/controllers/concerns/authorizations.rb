# frozen_string_literal: true

module Authorizations
  protected

  def cookie_name
    ENV.fetch( "AUTH_COOKIE_NAME", "auth_token" )
  end

  def authorize_by_cookie( expected_role )
    given_token = cookies[ cookie_name ]
    return unauthorized if given_token.blank?
    return nil if token_has_role? given_token, expected_role

    unauthorized
  end

  def authorize_by_header( expected_role )
    given_token = request.headers[ "Authorization" ]
    return unauthorized if given_token.blank?

    pieces = given_token.split
    return unauthorized if pieces.size != 2 || pieces.first != "Bearer"
    return nil if token_has_role? pieces.second, expected_role

    unauthorized
  end

  private

  def token_has_role?( given_token, expected_role )
    body = JWT.decode(
      given_token,
      public_key,
      true,
      { algorithm: Token::SIGNING_ALG, verify_expiration: true }
    )
    return false if body&.size&.zero?

    body.first[ "roles" ].include? expected_role
  rescue JWT::DecodeError
    false
  end

  def public_key
    OpenSSL::PKey::RSA.new ENV[ "JWT_RSA_PUB" ]
  end
end
