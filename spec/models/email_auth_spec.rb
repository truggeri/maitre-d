# frozen_string_literal: true

# == Schema Information
#
# Table name: email_auths
#
#  id                       :bigint           not null, primary key
#  email                    :string(255)
#  last_logged_in_at        :datetime
#  password_digest          :string(255)
#  recovery_password_digest :string(255)
#  patron_id                :bigint           not null
#
# Indexes
#
#  index_email_auths_on_email      (email) UNIQUE
#  index_email_auths_on_patron_id  (patron_id)
#
# Foreign Keys
#
#  fk_rails_...  (patron_id => patrons.id)
#
require "rails_helper"

describe EmailAuth, type: :model do
  describe "relationships" do
    it { expect( subject ).to belong_to :patron }
  end

  describe "validations" do
    it "validates" do
      patron = Patron.create! external_id: "abc"
      EmailAuth.create!(
        patron: patron,
        email: "sponge@bob.com",
        password: "password1234",
        password_confirmation: "password1234"
      )
      expect( subject ).to validate_uniqueness_of( :email ).case_insensitive
      expect( subject ).to allow_value( "TEST-123_456@dev.net" ).for :email
    end
  end

  describe "before_validates" do
    subject { instance.valid? }

    let( :instance ) do
      EmailAuth.new(
        patron: patron,
        email: "PatrickStar@SpongeBob.com",
        password: "password1234",
        password_confirmation: "password1234"
      )
    end
    let( :patron ) { Patron.create! external_id: "abc" }

    it "downcases email" do
      subject
      expect( instance.email ).to eq "patrickstar@spongebob.com"
    end
  end

  describe "#roles" do
    subject { instance.roles }

    let( :instance ) do
      EmailAuth.new(
        patron: patron,
        email: "PatrickStar@SpongeBob.com",
        password: "password1234",
        password_confirmation: "password1234"
      )
    end
    let( :patron ) { Patron.create! external_id: "abc", roles: [ role ] }
    let( :role ) { Role.create! name: "somerole" }

    it do
      expect( subject ).to eq [ "somerole" ]
    end
  end
end
