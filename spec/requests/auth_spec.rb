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

    let( :given_type ) { "email" }

    before do
      patron = Patron.create! external_id: "abc", auth_type: given_type
      EmailAuth.create! patron: patron, email: "someuser", password: "password1234"
    end

    context "when params missing" do
      let( :given_params ) { { username: "someuser" } }

      it do
        subject
        expect( response ).to have_http_status :bad_request
        expect( response.cookies ).not_to include "auth_token"
      end
    end

    context "when params don't match user" do
      let( :given_params ) { { username: "someuser", password: "bad_password" } }

      it do
        subject
        expect( response ).to have_http_status :unauthorized
        expect( response.cookies ).not_to include "auth_token"
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

      context "when auth_type isn't 'email'" do
        let( :given_type ) { "none" }

        it do
          subject
          expect( response ).to have_http_status :unauthorized
          expect( response.cookies ).not_to include "auth_token"
        end
      end
    end
  end

  describe "GET /logout" do
    subject { get logout_path }

    before do
      cookies[ "auth_token" ] = "some-value"
    end

    it do
      subject
      expect( response ).to redirect_to "/"
      expect( response.cookies[ "auth_token" ] ).to eq nil
    end

    context "when continue path" do
      subject { get logout_path( continue: "/continue/on" ) }

      it do
        subject
        expect( response ).to redirect_to "/continue/on"
        expect( response.cookies[ "auth_token" ] ).to eq nil
      end
    end
  end

  describe "POST /token" do
    subject { post token_path( id: given_id, token: given_token ) }

    let( :given_id ) { "given_id" }
    let( :given_token ) { "a-token-for-security" }
    let( :token_mock ) { instance_double( "Token", to_s: "a.b.c", id: "12345" ) }

    before do
      allow( Token ).to receive( :new ).and_return token_mock
    end

    context "when token is bad" do
      let( :given_token ) { "not-the-right-token" }

      it do
        subject
        expect( response ).to have_http_status :unauthorized
        expect( response.cookies ).not_to include "auth_token"
      end
    end

    context "when id not found" do
      it do
        subject
        expect( response ).to have_http_status :not_found
        expect( response.cookies ).not_to include "auth_token"
      end
    end

    context "when id found" do
      let( :given_type ) { "none" }

      before do
        Patron.create! external_id: given_id, auth_type: given_type
      end

      it do
        subject
        expect( response ).to redirect_to "/"
        expect( response.cookies ).to include( "auth_token" => "a.b.c" )
      end

      context "when patron type is not 'none'" do
        let( :given_type ) { "email" }

        it do
          subject
          expect( response ).to have_http_status :not_found
          expect( response.cookies ).not_to include "auth_token"
        end
      end
    end
  end
end
