# frozen_string_literal: true

# == Schema Information
#
# Table name: roles
#
#  id            :bigint           not null, primary key
#  name          :string
#  resource_type :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  resource_id   :bigint
#
# Indexes
#
#  index_roles_on_name      (name)
#  index_roles_on_resource  (resource_type,resource_id)
#
require "rails_helper"

describe Role, type: :model do
  describe "relationships" do
    it do
      expect( subject ).to have_and_belong_to_many( :patrons )
      expect( subject ).to belong_to( :resource ).optional
    end
  end

  describe "validations" do
    it do
      expect( subject ).to validate_inclusion_of( :resource_type ).in_array Rolify.resource_types
    end
  end
end
