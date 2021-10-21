# frozen_string_literal: true

require "rails_helper"

describe "RSA keys used for test" do
  let( :private_pem ) { ENV[ "JWT_RSA_PEM" ] }
  let( :private_key ) { OpenSSL::PKey::RSA.new private_pem }
  let( :public_pem ) { ENV[ "JWT_RSA_PUB" ] }
  let( :public_key ) { OpenSSL::PKey::RSA.new public_pem }

  it "does not have blank keys" do
    expect( :private_pem ).not_to be_blank
    expect( :public_pem ).not_to be_blank
  end

  it "has valid keys" do
    expect( private_key.to_s ).not_to be_blank
    expect( private_key.private? ).to eq true
    expect( public_key.to_s ).not_to be_blank
    expect( public_key.public? ).to eq true
  end

  it "has a matching private public keyset" do
    data = "Sign me!"
    signature = private_key.sign_pss(
      "SHA256",
      data,
      salt_length: :max,
      mgf1_hash: "SHA256"
    )
    result = public_key.verify_pss(
      "SHA256",
      signature,
      data,
      salt_length: :auto,
      mgf1_hash: "SHA256"
    )
    expect( result ).to eq true
  end
end
