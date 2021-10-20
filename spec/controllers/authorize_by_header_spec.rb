# frozen_string_literal: true

require "rails_helper"

describe "authorize_by_header", type: :controller do
  controller do
    before_action -> { authorize_by_header "manage_roles" }

    def authorize_header
      head :ok
    end
  end

  before do
    routes.draw { get "authorize_header" => "anonymous#authorize_header" }
  end

  subject do
    Timecop.freeze( time_of_test ) do
      get :authorize_header
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
    request.headers[ "Authorization" ] = given_header
  end

  context "when header is missing" do
    let( :given_header ) { nil }

    it do
      subject
      expect( response ).to have_http_status :unauthorized
    end
  end

  context "when header is malformed" do
    let( :given_header ) { "a.b.c" }

    it do
      subject
      expect( response ).to have_http_status :unauthorized
    end
  end

  context "when unauthorized" do
    let( :given_header ) { "Bearer #{ unauthorized_token }" }

    it do
      subject
      expect( response ).to have_http_status :unauthorized
    end
  end

  context "when authorized" do
    let( :given_header ) { "Bearer #{ authorized_token }" }

    it do
      subject
      expect( response ).to have_http_status :ok
    end

    context "when token expired" do
      let( :time_of_test ) { "2021-10-20-23:11:00Z" }

      it do
        subject
        expect( response ).to have_http_status :unauthorized
      end
    end
  end
end
