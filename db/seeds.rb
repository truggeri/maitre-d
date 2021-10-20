# frozen_string_literal: true

[ "superadmin", "manage", "view" ].each do | name |
  Role.find_or_create_by name: name
end

admin = Patron.find_or_create_by external_id: "someadmin", auth_type: :email
EmailAuth.find_or_create_by patron: admin, email: "someadmin@site.com"
admin.add_role :superadmin

manager = Patron.find_or_create_by external_id: "somemanager"
manager.add_role :manage

viewer = Patron.find_or_create_by external_id: "someviewer", auth_type: :email
EmailAuth.find_or_create_by patron: viewer, email: "someviewer@site.com"
viewer.add_role :view
