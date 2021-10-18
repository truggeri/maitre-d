# frozen_string_literal: true

[ "superadmin", "manage", "view" ].each do | name |
  Role.find_or_create_by name: name
end

admin = Patron.find_or_create_by external_id: "someadmin"
admin.add_role :superadmin

manager = Patron.find_or_create_by external_id: "somemanager"
manager.add_role :manage

viewer = Patron.find_or_create_by external_id: "someviewer"
viewer.add_role :view
