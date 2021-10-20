# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def cookie_name
    ENV.fetch( "AUTH_COOKIE_NAME", "auth_token" )
  end
end
