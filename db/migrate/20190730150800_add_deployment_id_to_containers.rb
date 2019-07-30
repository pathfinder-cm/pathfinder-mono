class AddDeploymentIdToContainers < ActiveRecord::Migration[5.2]
  def change
    add_column :containers, :deployment_id, :integer
    add_foreign_key :containers, :deployments
  end
end
