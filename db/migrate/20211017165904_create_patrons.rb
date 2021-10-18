# frozen_string_literal: true

class CreatePatrons < ActiveRecord::Migration[ 6.1 ]
  def change
    create_table :patrons do | t |
      t.string :external_id, null: false, limit: 255
      t.timestamps
    end

    add_index :patrons, :external_id, unique: true
  end
end
