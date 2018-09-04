class AddMemInfoToNodes < ActiveRecord::Migration[5.2]
  def change
    add_column :nodes, :mem_free_mb, :integer, limit: 8
    add_column :nodes, :mem_used_mb, :integer, limit: 8
    add_column :nodes, :mem_total_mb, :integer, limit: 8
  end
end
