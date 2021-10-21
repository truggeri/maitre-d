# frozen_string_literal: true

require "rails_helper"

describe Token do
  let( :instance ) { described_class.new roles: given_roles, id: uuid }
  let( :uuid ) { "c883acd1-5064-4349-87ad-60d4a63f8dca" }
  let( :frozen_time ) { Time.parse( "2021-10-16 08:24:12Z" ) }

  around( :example ) do | example |
    Timecop.freeze( frozen_time ) do
      example.run
    end
  end

  describe "#to_s" do
    subject { instance.to_s }

    context "when roles are blank" do
      let( :given_roles ) { [] }

      it do
        # rubocop:disable Layout/LineLength
        given_jwt = subject.split "."
        expect( given_jwt.first ).to eq "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9"
        expect( given_jwt.second ).to eq "eyJhdWQiOiJwdWJsaWMiLCJleHAiOjE2MzQzNzYyNTIsImlhdCI6MTYzNDM3MjY1MiwiaXNzIjoibWFpdHJlLWQiLCJqdGkiOiJjODgzYWNkMS01MDY0LTQzNDktODdhZC02MGQ0YTYzZjhkY2EiLCJyb2xlcyI6W119"
        # rubocop:enable Layout/LineLength
      end
    end

    context "when roles are present" do
      let( :given_roles ) { [ :sys_admin, :master_chef ] }

      it do
        # rubocop:disable Layout/LineLength
        given_jwt = subject.split "."
        expect( given_jwt.first ).to eq "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9"
        expect( given_jwt.second ).to eq "eyJhdWQiOiJwdWJsaWMiLCJleHAiOjE2MzQzNzYyNTIsImlhdCI6MTYzNDM3MjY1MiwiaXNzIjoibWFpdHJlLWQiLCJqdGkiOiJjODgzYWNkMS01MDY0LTQzNDktODdhZC02MGQ0YTYzZjhkY2EiLCJyb2xlcyI6WyJzeXNfYWRtaW4iLCJtYXN0ZXJfY2hlZiJdfQ"
        # rubocop:enable Layout/LineLength
      end

      context "when id not given" do
        let( :instance ) { described_class.new roles: given_roles }
        let( :generated_string ) { "some-generated-string" }

        it "uses generated uuid" do
          allow( SecureRandom ).to receive( :uuid ).and_return generated_string
          # rubocop:disable Layout/LineLength
          given_jwt = subject.split "."
          expect( given_jwt.first ).to eq "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9"
          expect( given_jwt.second ).to eq "eyJhdWQiOiJwdWJsaWMiLCJleHAiOjE2MzQzNzYyNTIsImlhdCI6MTYzNDM3MjY1MiwiaXNzIjoibWFpdHJlLWQiLCJqdGkiOiJzb21lLWdlbmVyYXRlZC1zdHJpbmciLCJyb2xlcyI6WyJzeXNfYWRtaW4iLCJtYXN0ZXJfY2hlZiJdfQ"
          # rubocop:enable Layout/LineLength
        end
      end

      context "when pem not found" do
        it do
          allow( ENV ).to receive( :[] ).with( "JWT_RSA_PEM" ).and_return nil
          expect { described_class.secret }.to raise_error ArgumentError
        end
      end
    end

    describe "signature" do
      it "can decode an encoded token" do
        new_token = described_class.new roles: [ "mechanic", "business_owner" ], id: "foo-bar"
        token = new_token.to_s
        body = JWT.decode(
          token,
          OpenSSL::PKey::RSA.new( ENV[ "JWT_RSA_PUB" ] ),
          true,
          { algorithm: described_class::SIGNING_ALG, verify_expiration: true }
        )
        expect( body.first[ "roles" ] ).to eq( [ "mechanic", "business_owner" ] )
        expect( body.first[ "aud" ] ).to eq "public"
        expect( body.first[ "iss" ] ).to eq "maitre-d"
        expect( body.first[ "jti" ] ).to eq "foo-bar"
      end
    end
  end
end
