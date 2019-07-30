# frozen_string_literal: true

class CreateDeployments < ActiveRecord::Migration[5.2]
  def change
    create_table :deployments do |t|
      t.string  :name,    null: false
      t.integer :replicas,  null: false
      t.string  :label
      t.string  :status
      t.jsonb   :strategy, null: false, default: {}

      t.timestamps null: false
    end

    add_index :deployments, :name
  end
end
