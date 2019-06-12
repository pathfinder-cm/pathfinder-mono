# frozen_string_literal: true

class CreateRemotes < ActiveRecord::Migration[5.2]
  def change
    create_table :remotes do |t|
      t.string  :name,        null: false
      t.string  :server
      t.string  :protocol,    null: false
      t.string  :auth_type,   null: false
      t.text    :certificate

      t.timestamps null: false
    end

    add_index :remotes, :name, unique: true
  end
end
