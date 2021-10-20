# frozen_string_literal: true

# == Schema Information
#
# Table name: patrons
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  external_id :string(255)      not null
#
# Indexes
#
#  index_patrons_on_external_id  (external_id) UNIQUE
#
require "rails_helper"

describe EmailAuth, type: :model do
  describe "relationships" do
    it { expect( subject ).to belong_to :patron }
  end

  describe "validations" do
    it "validates" do
      patron = Patron.create! external_id: "abc"
      EmailAuth.create! patron: patron, email: "sponge@bob.com"
      expect( subject ).to validate_uniqueness_of( :email ).case_insensitive
      expect( subject ).to allow_value( "TEST-123_456@dev.net" ).for :email
    end
  end

  describe "before_validates" do
    subject { instance.valid? }

    let( :instance ) { EmailAuth.new patron: patron, email: "PatrickStar@SpongeBob.com" }
    let( :patron ) { Patron.create! external_id: "abc" }

    it "downcases email" do
      subject
      expect( instance.email ).to eq "patrickstar@spongebob.com"
    end
  end
end
