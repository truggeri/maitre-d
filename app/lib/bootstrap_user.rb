# frozen_string_literal: true

class BootstrapUser
  def self.create!( username, password )
    return nil if username.blank? || password.blank?

    patron = Patron.find_or_create_by!( auth_type: "email", external_id: "maitre-d-superadmin" )
    patron.email_auth&.destroy!
    EmailAuth.create!(
      patron: patron,
      email: username,
      password: password,
      password_confirmation: password
    )
    patron.add_role "manage_roles"
  end
end
