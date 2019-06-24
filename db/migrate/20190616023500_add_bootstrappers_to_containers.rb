class AddBootstrappersToContainers < ActiveRecord::Migration[5.2]
  def change
    add_column :containers, :bootstrappers, :jsonb, null: false, default: []
  end
end
