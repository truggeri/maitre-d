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

describe Patron, type: :model do
  describe "validations" do
    it do
      Patron.create! external_id: "a-b-c-d"
      expect( subject ).to validate_presence_of :external_id
      expect( subject ).to validate_uniqueness_of :external_id
      expect( subject ).to validate_length_of( :external_id ).is_at_most 255
    end
  end
end
