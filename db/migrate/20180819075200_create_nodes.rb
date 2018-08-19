# frozen_string_literal: true

class CreateNodes < ActiveRecord::Migration[5.2]
  def change
    create_table :nodes do |t|
      t.integer :cluster_id,  null: false
      t.string  :hostname,    null: false
      t.string  :ipaddress

      t.timestamps null: false
    end

    add_foreign_key :nodes, :clusters
    add_index :nodes, [:hostname], unique: true
  end
end
