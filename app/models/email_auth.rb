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
class EmailAuth < ApplicationRecord
  before_validation :downcase_email

  belongs_to :patron, optional: false
  has_secure_password
  has_secure_password :recovery_password, validations: false

  validates :email,
            uniqueness: { case_sensitive: false },
            length: { maximum: 255 },
            allow_nil: true,
            format: { with: /\A[a-zA-Z0-9_\-@.]+\z/ }

  def roles
    patron.roles.map( &:name )
  end

  private

  def downcase_email
    self.email = email&.downcase
  end
end
