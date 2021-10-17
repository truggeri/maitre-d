# frozen_string_literal: true

class AuthenticationsController < ApplicationController
  before_action :generate_token

  def set
    cookies[ cookie_name ] = {
      value: @token.to_s,
      expires: 1.hour,
      same_site: :Strict,
    }
    return head( :ok ) if params[ :next_path ].blank?

    redirect_to params[ :next_path ]
  end

  private

  def generate_token
    @token = Token.new( id: request.request_id, roles: [ :a, :b, :c ] )
    return nil if @token.present?

    render( plain: "Could not generate token", status: :bad_request )
  end

  def cookie_name
    ENV.fetch( "AUTH_COOKIE_NAME", "auth_token" )
  end
end
