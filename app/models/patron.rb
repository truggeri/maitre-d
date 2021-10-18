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
class Patron < ApplicationRecord
  validates :external_id, presence: true, uniqueness: true, length: { maximum: 255 }
end
