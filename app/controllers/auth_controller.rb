# frozen_string_literal: true

class AuthController < ApplicationController
  before_action :normazlie_continue
  before_action :verify_login_params, only: [ :login ]
  before_action :validate_user, only: [ :login ]

  def login_form; end

  def login
    @user.update! last_logged_in_at: Time.now.utc
    auth_cookie Token.new( id: request.request_id, roles: @user.roles )
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
    return nil if @user&.authenticate params[ :password ]

    flash[ :error ] = "Invalid credentials"
    render status: :unauthorized, template: "auth/login_form"
  end

  def auth_cookie( token )
    cookies[ cookie_name ] = {
      value: token.to_s,
      expires: 1.hour,
      same_site: :Strict,
    }
  end

  def cookie_name
    ENV.fetch( "AUTH_COOKIE_NAME", "auth_token" )
  end
end
