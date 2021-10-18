# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Token" do
  let( :instance ) { Token.new roles: given_roles, id: uuid }
  let( :uuid ) { "c883acd1-5064-4349-87ad-60d4a63f8dca" }
  let( :frozen_time ) { Time.parse( "2021-10-16 08:24:12Z" ) }

  around( :example ) do | example |
    Timecop.freeze( frozen_time ) do
      example.run
    end
  end

  describe "#.to_s" do
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
        let( :instance ) { Token.new roles: given_roles }
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
          expect { Token.secret }.to raise_error ArgumentError
        end
      end
    end
  end
end
