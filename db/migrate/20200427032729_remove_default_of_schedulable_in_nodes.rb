class RemoveDefaultOfSchedulableInNodes < ActiveRecord::Migration[5.2]
  def change
    change_column_default :nodes, :schedulable, nil
  end
end
