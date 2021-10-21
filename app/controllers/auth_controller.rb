# frozen_string_literal: true

class AuthController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [ :logout, :token ]
  before_action :normazlie_continue

  before_action :verify_login_params, only: [ :login ]
  before_action :validate_user, only: [ :login ]

  before_action :validate_auth, only: [ :token ]
  before_action :load_patron, only: [ :token ]

  def login_form; end

  def login
    @user.update! last_logged_in_at: Time.now.utc
    auth_cookie Token.new( id: request.request_id, roles: @user.roles )
    redirect_to params[ :continue ]
  end

  def logout
    cookies[ cookie_name ] = nil
    redirect_to params[ :continue ]
  end

  def token
    auth_cookie Token.new( id: request.request_id, roles: @patron.roles.map( &:name ) )
    redirect_to params[ :continue ]
  end

  private

  def normazlie_continue
    params[ :continue ] ||= "/"
  end

  def verify_login_params
    return nil if params.key?( :username ) && params.key?( :password )

    flash[ :error ] = "Request is invlaid, parameters are missing"
    render status: :bad_request, template: "auth/login_form"
  end

  def validate_user
    @user = EmailAuth.find_by email: params[ :username ]
    return nil if @user&.patron&.email? && @user.authenticate( params[ :password ] )

    flash[ :error ] = "Invalid credentials"
    render status: :unauthorized, template: "auth/login_form"
  end

  def validate_auth
    return nil if params[ :token ] == ENV[ "SECURITY_TOKEN" ]

    head :unauthorized
  end

  def load_patron
    @patron = Patron.find_by external_id: params[ :id ]
    return nil if @patron&.external?

    head :not_found
  end

  def auth_cookie( token )
    cookies[ cookie_name ] = {
      value: token.to_s,
      expires: 1.hour,
      same_site: :Strict,
    }
  end
end
