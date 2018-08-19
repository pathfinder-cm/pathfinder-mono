# frozen_string_literal: true

class CreateContainers < ActiveRecord::Migration[5.2]
  def change
    create_table :containers do |t|
      t.integer   :cluster_id,  null: false
      t.string    :hostname,    null: false
      t.string    :ipaddress
      t.string    :image,       null: false
      t.integer   :node_id
      t.string    :status,      null: false

      t.datetime  :last_status_update_at
      t.timestamps null: false
    end

    add_foreign_key :containers, :clusters
    add_foreign_key :containers, :nodes
    add_index :containers, [:cluster_id, :hostname], unique: true
  end
end
