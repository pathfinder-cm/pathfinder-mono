# frozen_string_literal: true

class CreateSources < ActiveRecord::Migration[5.2]
  def change
    create_table :sources do |t|
      t.string  :type,         null: false
      t.string  :mode,         null: false
      t.integer :remote_id
      t.string  :fingerprint
      t.string  :alias

      t.timestamps null: false
    end

    add_foreign_key :sources, :remotes
    add_index :sources, :fingerprint
    add_index :sources, :alias
  end
end
