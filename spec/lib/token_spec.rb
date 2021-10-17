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
        jwt = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiJwdWJsaWMiLCJleHAiOjE2MzQzNzYyNTIsImlhdCI6MTYzNDM3MjY1MiwiaXNzIjoibWFpdHJlLWQiLCJqdGkiOiJjODgzYWNkMS01MDY0LTQzNDktODdhZC02MGQ0YTYzZjhkY2EiLCJyb2xlcyI6W119.aapd0uuZ8ay43r4RmuCW3I67S3FoRg9WS_1TWMrHEISXHH1PBUnrPkWDueBB8XtPG453yyxjCyEl3osQjiiIe1Ge59bePyQF-58egAEBFlig39DvuYto5dz4tYPnxff164BY4Mzqlvs9Dr3V7BkFqmop5EaXebOy_dctrlzhkkfuwIpsgwEWOyqhMDR5jjrPC-neawmGbwc_KrT7fJOzEmcS33gSFLOltF_6bVWBwF7k5nJMRefqak3GB_K0dnQtNtxy3IPac5b6Dhci42iuAw8HL7ZUY_BwAOigopA9HM_9HeXtvdypgBz-TJpynH2-FVz-gX7htwGTNmbRX8m6yw"
        # rubocop:enable Layout/LineLength
        expect( subject ).to eq jwt
      end
    end

    context "when roles are present" do
      let( :given_roles ) { [ :sys_admin, :master_chef ] }

      it do
        # rubocop:disable Layout/LineLength
        jwt = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiJwdWJsaWMiLCJleHAiOjE2MzQzNzYyNTIsImlhdCI6MTYzNDM3MjY1MiwiaXNzIjoibWFpdHJlLWQiLCJqdGkiOiJjODgzYWNkMS01MDY0LTQzNDktODdhZC02MGQ0YTYzZjhkY2EiLCJyb2xlcyI6WyJzeXNfYWRtaW4iLCJtYXN0ZXJfY2hlZiJdfQ.aXVgzZSj19v2GW2fWM7CNVIHZS_rSsSk5Nm8NkwIJ7dXY9dPgMHBhsxe7vyZBtrXL57hiOeub2V1B98f-SGr_JjL_3bAXYOZctDG1wLbiqwaXRTY68n86x0KSm3fcqPCaqKgIXNFMUaYr9F2pmXDLkuN7-6TYE2Z_zjYHLbEvfAzi_QLqeZuSbv5OrzUGdBAcIJ5_RFTOtcfjnh6mBboiV4c3cOEUVpprVAHQToQvuVbMOUMa4g4dWyOUQzzAwH_NR_EmG4eSXBZ6nQjTuidd1qIQ_YUb28z85_oFfWy2E50Nf1Zlbh8WlEh9CAVbGZeANEmVyII4oBVAiA-_QqaXA"
        # rubocop:enable Layout/LineLength
        expect( subject ).to eq jwt
      end

      context "when id not given" do
        let( :instance ) { Token.new roles: given_roles }
        let( :generated_string ) { "some-generated-string" }

        it "uses generated uuid" do
          allow( SecureRandom ).to receive( :uuid ).and_return generated_string
          # rubocop:disable Layout/LineLength
          jwt = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiJwdWJsaWMiLCJleHAiOjE2MzQzNzYyNTIsImlhdCI6MTYzNDM3MjY1MiwiaXNzIjoibWFpdHJlLWQiLCJqdGkiOiJzb21lLWdlbmVyYXRlZC1zdHJpbmciLCJyb2xlcyI6WyJzeXNfYWRtaW4iLCJtYXN0ZXJfY2hlZiJdfQ.dyfYMoS12sv754HyPuUx3DtY8YQnjUIeM8kOxhR0EkDvCA3xVmJHhgXah_5Cj5s_PfKPlzV5DmII57p26SxzsmjED329irqysYWEuolJxdwlTBe-1Z9NaR2WlxX--C4-ecZF49kXYnvDbjNq5yqsi6gMJXWmGvZkSH9D8QmhLAdMBOpHVg6zxM2ESnzLZ03qsSBz4nkpgGbQ47tlhyFXynBKDp5U-T83DCzlQlhnUV2jfNp6bpNv0kAtGQHWwH5h76gPEBZoAqZr386UQYNjY2NuPJ5rZp3k49YiSJoq0cn_nIKItQMXAvWSRw3WY9EJjDVMaAK6PjbacHpVAhpXvA"
          # rubocop:enable Layout/LineLength
          expect( subject ).to eq jwt
        end
      end
    end
  end
end
