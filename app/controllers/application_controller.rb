# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Authorizations

  def unauthorized
    return head( :unauthorized ) if ENV[ "HARD_UNAUTH" ] == "true"

    redirect_to login_form_path( continue: request.path )
  end
end
