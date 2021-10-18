# frozen_string_literal: true

class RolifyCreateRoles < ActiveRecord::Migration[ 6.1 ]
  def change
    create_table( :roles ) do | t |
      t.string :name
      t.references :resource, polymorphic: true

      t.timestamps
    end

    create_table( :patrons_roles, id: false ) do | t |
      t.references :patron, foreign_key: true, index: false, null: false
      t.references :role, foreign_key: true, index: false, null: false
    end

    add_index :roles, [ :name ]
    add_index :patrons_roles, [ :patron_id, :role_id ], unique: true
  end
end
