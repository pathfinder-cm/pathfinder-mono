class AddSchedulableToNodes < ActiveRecord::Migration[5.2]
  def change
    add_column :nodes, :schedulable, :boolean, null: false, default: true
  end
end
