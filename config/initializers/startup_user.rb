# frozen_string_literal: true

if ENV[ "SUPERADMIN_USERNAME" ].present? && ENV[ "SUPERADMIN_PASSWORD" ].present?
  patron = Patron.find_or_create_by!( auth_type: "email", external_id: "maitre-d-superadmin" )
  patron.email_auth&.destroy!
  EmailAuth.create!(
    patron: patron,
    email: ENV[ "SUPERADMIN_USERNAME" ],
    password: ENV[ "SUPERADMIN_PASSWORD" ],
    password_confirmation: ENV[ "SUPERADMIN_PASSWORD" ]
  )
  patron.add_role "manage_roles"
end
