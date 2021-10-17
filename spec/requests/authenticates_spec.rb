# frozen_string_literal: true

require "rails_helper"

describe "Authenticates", type: :request do
  describe "GET /set" do
    subject { get authenticate_path }

    let( :token_mock ) { instance_double( "Token", to_s: "a.b.c", id: "12345" ) }

    before do
      allow( Token ).to receive( :new ).and_return token_mock
    end

    it do
      subject
      expect( response ).to have_http_status :ok
      expect( response.cookies ).to include( "auth_token" => "a.b.c" )
    end

    context "when next_path given" do
      subject { get authenticate_path( next_path: "https://www.google.com" ) }

      it do
        subject
        expect( response ).to redirect_to "https://www.google.com"
      end
    end

    context "when token cannot be generated" do
      let( :token_mock ) { nil }

      it do
        subject
        expect( response ).to have_http_status :bad_request
      end
    end
  end
end
