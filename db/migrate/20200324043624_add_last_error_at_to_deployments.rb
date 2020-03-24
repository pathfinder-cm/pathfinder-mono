class AddLastErrorAtToDeployments < ActiveRecord::Migration[5.2]
  def change
    add_column :deployments, :last_error_at, :datetime
  end
end
