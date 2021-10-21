# frozen_string_literal: true

require "rails_helper"

describe "authorize_by_cookie", type: :controller do
  controller do
    before_action -> { authorize_by_cookie "manage_roles" }

    def authorize_cookie
      head :ok
    end
  end

  before do
    routes.draw { get "authorize_cookie" => "anonymous#authorize_cookie" }
  end

  subject do
    get :authorize_cookie
  end

  let( :unauthorized_token ) { Token.new( roles: [ "line_cook" ] ).to_s }
  let( :authorized_token ) { Token.new( roles: [ "manage_roles" ] ).to_s }
  let( :expired_token ) do
    Timecop.freeze( 65.minutes.ago ) do
      Token.new( roles: [ "manage_roles", "old_stuff" ] ).to_s
    end
  end

  before do
    cookies[ "auth_token" ] = given_cookie
  end

  context "when cookie is missing" do
    let( :given_cookie ) { nil }

    it do
      subject
      expect( response ).to have_http_status :unauthorized
    end
  end

  context "when cookie is malformed" do
    let( :given_cookie ) { "a.b.c" }

    it do
      subject
      expect( response ).to have_http_status :unauthorized
    end
  end

  context "when unauthorized" do
    let( :given_cookie ) { unauthorized_token }

    it do
      subject
      expect( response ).to have_http_status :unauthorized
    end

    context "when not HARD_UNAUTH" do
      before do
        allow( ENV ).to receive( :[] ).and_call_original
        allow( ENV ).to receive( :[] ).with( "HARD_UNAUTH" ).and_return "false"
      end

      it do
        subject
        expect( response ).to redirect_to login_form_path( continue: "/authorize_cookie" )
      end
    end
  end

  context "when authorized" do
    let( :given_cookie ) { authorized_token }

    it do
      subject
      expect( response ).to have_http_status :ok
    end
  end

  context "when token expired" do
    let( :given_cookie ) { expired_token }

    it do
      subject
      expect( response ).to have_http_status :unauthorized
    end
  end
end
