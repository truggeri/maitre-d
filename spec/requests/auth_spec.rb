# frozen_string_literal: true

require "rails_helper"

describe "Auth", type: :request do
  describe "GET /login" do
    subject { get login_form_path }

    it do
      subject
      expect( response ).to have_http_status :ok
      expect( response.body ).to include(
        "<input value=\"/\" type=\"hidden\" name=\"continue\" id=\"continue\" />"
      )
    end

    context "when continue param set" do
      subject { get login_form_path( continue: "/next-path" ) }

      it "saves given param to form" do
        subject
        expect( response ).to have_http_status :ok
        expect( response.body ).to include(
          "<input value=\"/next-path\" type=\"hidden\" name=\"continue\" id=\"continue\" />"
        )
      end
    end
  end

  describe "POST /login" do
    subject { post login_path( given_params ) }

    before do
      patron = Patron.create! external_id: "abc"
      EmailAuth.create! patron: patron, email: "someuser", password: "password1234"
    end

    context "when params missing" do
      let( :given_params ) { { username: "someuser" } }

      it do
        subject
        expect( response ).to have_http_status :bad_request
      end
    end

    context "when params don't match user" do
      let( :given_params ) { { username: "someuser", password: "bad_password" } }

      it do
        subject
        expect( response ).to have_http_status :unauthorized
      end
    end

    context "when params are good" do
      let( :given_params ) { { username: "someuser", password: "password1234" } }
      let( :token_mock ) { instance_double( "Token", to_s: "a.b.c", id: "12345" ) }

      before do
        allow( Token ).to receive( :new ).and_return token_mock
      end

      it do
        subject
        expect( response ).to redirect_to "/"
        expect( response.cookies ).to include( "auth_token" => "a.b.c" )
        expect( EmailAuth.last.last_logged_in_at ).to be_within( 1.minute ).of Time.now.utc
      end
    end
  end
end
