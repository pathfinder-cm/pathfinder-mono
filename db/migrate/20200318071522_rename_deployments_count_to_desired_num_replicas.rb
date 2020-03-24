class RenameDeploymentsCountToDesiredNumReplicas < ActiveRecord::Migration[5.2]
  def change
    rename_column :deployments, :count, :desired_num_replicas
  end
end
