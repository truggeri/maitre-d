# frozen_string_literal: true

class AddPatronTypeEnum < ActiveRecord::Migration[ 6.1 ]
  # reference: https://dev.to/amplifr/postgres-enums-with-rails-4ld0
  # reference: https://github.com/bibendi/activerecord-postgres_enum
  def up
    create_enum :authentication_type, [ "none", "email", "oauth2" ]
    add_column :patrons, :auth_type, :authentication_type, null: false, default: "none"
  end

  def down
    remove_column :patrons, :auth_type
    drop_enum :authentication_type
  end
end
