# frozen_string_literal: true

require "rails_helper"

describe "roles", type: :request do
  around do | example |
    Timecop.freeze( time_of_test ) do
      example.run
    end
  end

  let( :time_of_test ) { "2021-10-20-23:00:00Z" }
  let( :unauthorized_token ) do
    "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9." \
      "eyJhdWQiOiJwdWJsaWMiLCJleHAiOjE2MzQ3NzE5NDcsImlhdCI6MTYzNDc2ODM0NywiaXNzIjoibWFpdHJlLWQiLCJqdGkiOiJ" \
      "hYTIyZDM1Yi04M2ExLTRkYmUtOTA2YS04ZTEyYTc5Nzc0ZjQiLCJyb2xlcyI6WyJ2aWV3ZXIiXX0.K12aT0h45v-sjO-iVTkGDS" \
      "BfIWJmYu7KNbUOSi4bQRG-fuarbmgn98ZnMKT5JcjUkiz2YS9bjeVVIvbMPPW7FTz0arqErIvSrcvlreqSn5qQ438X_PS5LJzQL" \
      "Py4NT5p8Sb_zGZxUSyi9Wylp_92DTYOn6olt1lVfluIDLnnFt3isTShvIpLfXdMJuM6ukaNJJGNRj7Debw9HPWCd-rcDZaLW0iZ" \
      "vaSeXMdKQUX0YCAytOSq52FfIWBlD4_lfXsYz2EVr9n01dVMW5H4VxqlI1P93vm_TLVLm66aEyyrQwuFMaP4Ox-K_YBKS04el6w" \
      "UHV6nyAswOLfiEd6YDwdvBg"
  end
  let( :authorized_token ) do
    "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9." \
      "eyJhdWQiOiJwdWJsaWMiLCJleHAiOjE2MzQ3NzEzMDIsImlhdCI6MTYzNDc2NzcwMiwiaXNzIjoibWFpdHJlLWQiLCJqdGki" \
      "OiJhOWQwMDFiNS05MzZjLTQ4N2UtYTlmZC04MWYxZjQyNTM3MTAiLCJyb2xlcyI6WyJtYW5hZ2Vfcm9sZXMiXX0." \
      "d1rPMz7V6Gd8XlSE6XEgRuVjpRo5qYqaESUbo46n7hiJ4g2Yw13yX-4K-l6DRk9ag4memc26J6t0YszwS2pBwB1prtOdiVu--" \
      "wFIJxOH8Un7QQc4cMTbw_NaT1rhUAVSNo0Z92xd4LJm-8qKXkYl0UDoKgW-lbhpT8aHTcKzQfflI9hgUmJ1rOMXMahcBBAXV8" \
      "rYy12jLsA8xz0cVjwJaUr3P3t9nfLkRgrMPFURklgwnYIMqXkjiytw_neqmUEpWUtEd6WOKAppRWobigMz5M0yKPYhc0PfWO5" \
      "78shXCMtd2Yrke0VAaXIUWGMCn8ldOTsJTzJF8tHfR3ED8G1IZQ"
  end

  before do
    cookies[ "auth_token" ] = authorized_token
  end

  shared_examples_for "an unauthorized request" do
    context "when no token" do
      before do
        cookies[ "auth_token" ] = nil
      end

      it do
        subject
        expect( response ).to have_http_status :unauthorized
      end
    end

    context "when no unauthed token" do
      before do
        cookies[ "auth_token" ] = unauthorized_token
      end

      it do
        subject
        expect( response ).to have_http_status :unauthorized
      end
    end
  end

  describe "index" do
    subject { get roles_path }

    it do
      subject
      expect( response ).to have_http_status :ok
    end

    it_behaves_like "an unauthorized request"
  end

  describe "edit" do
    subject { get edit_role_path( name: given_name ) }

    let( :given_name ) { "fako" }

    it_behaves_like "an unauthorized request"

    context "when name doesn't exist" do
      it do
        subject
        expect( response ).to redirect_to roles_path
      end
    end

    context "when name does exist" do
      let( :given_name ) { role.name }
      let( :role ) { Role.create name: "test-role" }

      it do
        subject
        expect( response ).to have_http_status :ok
      end
    end
  end

  describe "update" do
    subject { patch role_path( name: given_name, params: given_params ) }

    let( :given_params ) do
      {
        role: { name: "new-name" },
      }
    end
    let( :given_name ) { "fako" }

    it_behaves_like "an unauthorized request"

    context "when name doesn't exist" do
      it do
        subject
        expect( response ).to redirect_to roles_path
      end
    end

    context "when name does exist" do
      let( :given_name ) { role.name }
      let( :role ) { Role.create name: "test-role" }

      it "updates the name" do
        subject
        expect( response ).to redirect_to roles_path
        expect( role.reload.name ).to eq "new-name"
      end

      context "when params are bad" do
        let( :given_params ) do
          {
            wrong: { name: "new-name" },
          }
        end

        it "does not update the name" do
          expect { subject }.to raise_error ActionController::ParameterMissing
        end
      end
    end
  end
end
