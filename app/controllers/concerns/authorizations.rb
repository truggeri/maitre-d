# frozen_string_literal: true

module Authorizations
  protected

  def cookie_name
    ENV.fetch( "AUTH_COOKIE_NAME", "auth_token" )
  end

  def authorizations_in_cookie?
    given_token = cookies[ cookie_name ]
    return false if given_token.blank?

    decode( given_token ).present?
  end

  def authorize_by_cookie( expected_role )
    given_token = cookies[ cookie_name ]
    return unauthorized if given_token.blank?
    return nil if token_has_role? given_token, expected_role

    unauthorized
  end

  def authorizations_in_header?
    given_token = request.headers[ "Authorization" ]
    return false if given_token.blank?

    pieces = given_token.split
    return false if pieces.size != 2 || pieces.first != "Bearer"

    decode( pieces.second ).present?
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
    payload = decode( given_token )

    payload[ "roles" ].include? expected_role
  rescue JWT::DecodeError
    false
  end

  def decode( given_token )
    body = JWT.decode(
      given_token,
      public_key,
      true,
      { algorithm: Token::SIGNING_ALG, verify_expiration: true }
    )
    return nil if body&.size&.zero?

    body.first
  end

  def public_key
    OpenSSL::PKey::RSA.new ENV[ "JWT_RSA_PUB" ]
  end
end
