# frozen_string_literal: true

class CreateEmailAuth < ActiveRecord::Migration[ 6.1 ]
  def change
    create_table :email_auths do | t |
      t.references :patron, null: false, foreign_key: true
      t.string :email, null: true, limit: 255
      t.string :password_digest, null: true, limit: 255
      t.string :recovery_password_digest, null: true, limit: 255
      t.datetime :last_logged_in_at
    end

    add_index :email_auths, :email, unique: true
  end
end
