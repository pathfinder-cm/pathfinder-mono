class ChangeDeploymentsMinAvailableCountToMinAvailableReplicas < ActiveRecord::Migration[5.2]
  def change
    rename_column :deployments, :min_available_count, :min_available_replicas
  end
end
