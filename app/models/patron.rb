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
class Patron < ApplicationRecord
  rolify

  enum auth_type: {
    external: "none",
    email: "email",
    oauth2: "oauth2",
  }

  has_one :email_auth, dependent: :destroy

  validates :external_id, presence: true, uniqueness: true, length: { maximum: 255 }
end
