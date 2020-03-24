class CreateDeployments < ActiveRecord::Migration[5.2]
  def change
    create_table :deployments do |t|
      t.references :cluster, null: false
      t.string  :name,       null: false
      t.integer :count,      null: false, default: 1
      t.jsonb   :definition, null: false
      t.timestamps
    end

    add_index :deployments, [:cluster_id, :name], unique: true
  end
end
