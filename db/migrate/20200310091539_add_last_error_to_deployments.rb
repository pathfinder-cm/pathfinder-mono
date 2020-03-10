class AddLastErrorToDeployments < ActiveRecord::Migration[5.2]
  def change
    add_column :deployments, :last_error, :string
  end
end
