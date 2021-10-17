# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Token" do
  let( :instance ) { Token.new roles: given_roles, id: uuid }
  let( :uuid ) { "c883acd1-5064-4349-87ad-60d4a63f8dca" }

  around( :example ) do | example |
    Timecop.freeze( 2021, 10, 16 ) do
      example.run
    end
  end

  describe "#.to_s" do
    subject { instance.to_s }

    context "when roles are blank" do
      let( :given_roles ) { [] }

      it do
        jwt = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiJwdWJsaWMiLCJleHAiOjE2MzQzNDYwMDAsImlhdCI6MTYzNDM0MjQ" \
              "wMCwiaXNzIjoibWFpdHJlLWQiLCJqdGkiOiJjODgzYWNkMS01MDY0LTQzNDktODdhZC02MGQ0YTYzZjhkY2EiLCJyb2xlcyI6W119." \
              "c64d6VNSMweCbmqBgEjppecJMVkJXsGV2bCvvp13njKkvKBur7bHMkHIeoyda3MM4VpNFNNfb-4SGKoi3rEidNtztrj5dzJTVoDCH" \
              "-gkR9n5xv2bK23D-X5bIe3s4oypwy9YCLE262MbFUYqEyiQY_IltseITCdU2jSAfIlxcDsNoZJjwwULwYiwq-Y6QTCx4n9IEUn-" \
              "eso05avjtho_It2LbFnArAI3JaHOIQuMrjwAk18UwuBV67knQ4wsT_YBP5i4NpMlwuu-SZplpx0sFkP96pBQgTwdV_9qUvlor1-" \
              "WLv04YDEC8pP4Ntk7BAJMqMkFr60dY05GubxELb052g"
        expect( subject ).to eq jwt
      end
    end

    context "when roles are present" do
      let( :given_roles ) { [ :sys_admin, :master_chef ] }

      it do
        jwt = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiJwdWJsaWMiLCJleHAiOjE2MzQzNDYwMDAsImlhdCI6MTYzNDM0MjQ" \
              "wMCwiaXNzIjoibWFpdHJlLWQiLCJqdGkiOiJjODgzYWNkMS01MDY0LTQzNDktODdhZC02MGQ0YTYzZjhkY2EiLCJyb2xlcyI6WyJz" \
              "eXNfYWRtaW4iLCJtYXN0ZXJfY2hlZiJdfQ.mstJrQNPLuWuNE9BF_Rf1v3jVUqB_r9Mu_jpNQNdHV-L9mRSCyh4BR7OrZrSZKS3kjD" \
              "5bI-RzKZb3SJkyyW6eT3Xw1PXl_Z362WhMfpWUUk801l9rW5s7rPNXm7mlmDAvwFUVUu1iu9RcRlW2x9O0IDbuin6AW5hNjeI4mYPw" \
              "StJCc28NWxMglTCIS1Mw3jEzCD5Il9oHtv4OSenaBVvreqYxSILeFevhVixVVd1N3p7StOE0zggVoN11nnF5eZsHO3dfNULUT2ZXl" \
              "OzP_wtJi2o7Q80j1x7hceX8binTQtnICSeORnOuwmoyepUKRD4OIvmq4nVEEYYxLGPuRHD9w"
        expect( subject ).to eq jwt
      end

      context "when id not given" do
        let( :instance ) { Token.new roles: given_roles }
        let( :generated_string ) { "some-generated-string" }

        it "uses generated uuid" do
          allow( SecureRandom ).to receive( :uuid ).and_return generated_string
          jwt = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiJwdWJsaWMiLCJleHAiOjE2MzQzNDYwMDAsImlhdCI6MTYzNDM0" \
                "MjQwMCwiaXNzIjoibWFpdHJlLWQiLCJqdGkiOiJzb21lLWdlbmVyYXRlZC1zdHJpbmciLCJyb2xlcyI6WyJzeXNfYWRtaW4iL" \
                "CJtYXN0ZXJfY2hlZiJdfQ.eN9-w_VpQvZcFGW3KMckPZXrY7IzsjB2aPWr0jeLWFqeqHoRphIND3B4lxGHHuPt3xKa9TOjpow" \
                "BZMYP43QDguFd2kmrcZ1QEXPZ_aTeMcsbXN8xMEM2hNCI7Du2aM0tKFdk0seVccb2p_zSf4gEv8rTOXdIp7DWCHGUXk19IdmH" \
                "A7wucqQuEoDlQ-ffYSJlBmeXKtmdvS7C5jPIlkv4fbyH9sljvBdBzGeuKtIwqXubpHOUBHLaKoqP5Igo9fAXTUjDrTuefTby2" \
                "erjs0aWJK738VvwkB3nimoJ4WOCrk4bKXZlNE3SRi7AiTITCcKjFqYejLtHHF4Orr0LeGy0ew"
          expect( subject ).to eq jwt
        end
      end
    end
  end
end
