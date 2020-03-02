class AddMinAvailableCountToDeployments < ActiveRecord::Migration[5.2]
  def change
    add_column :deployments, :min_available_count, :integer, null: false, default: 1
  end
end
