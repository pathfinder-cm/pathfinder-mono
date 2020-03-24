class ChangeDeploymentsLastErrorToLastErrorMsg < ActiveRecord::Migration[5.2]
  def change
    rename_column :deployments, :last_error, :last_error_msg
  end
end
