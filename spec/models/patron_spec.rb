# frozen_string_literal: true

# == Schema Information
#
# Table name: patrons
#
#  id          :bigint           not null, primary key
#  auth_type   :enum             default("none"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  external_id :string(255)      not null
#
# Indexes
#
#  index_patrons_on_external_id  (external_id) UNIQUE
#
require "rails_helper"

describe Patron, type: :model do
  describe "relationships" do
    it { expect( subject ).to have_one :email_auth }
  end

  describe "validations" do
    it "validates external_id" do
      Patron.create! external_id: "a-b-c-d"
      expect( subject ).to validate_presence_of :external_id
      expect( subject ).to validate_uniqueness_of :external_id
      expect( subject ).to validate_length_of( :external_id ).is_at_most 255
    end
  end

  describe "enums" do
    it do
      expect( subject ).to define_enum_for( :auth_type )
        .with_values(
          {
            external: "none",
            email: "email",
            oauth2: "oauth2",
          }
        ).backed_by_column_of_type( :enum )
    end
  end
end
