class AddLoadAndDiskMetricesToNodes < ActiveRecord::Migration[5.2]
  def change
    add_column :nodes, :load_capacity, :decimal
    add_column :nodes, :load_avg_1m, :decimal
    add_column :nodes, :load_avg_5m, :decimal
    add_column :nodes, :load_avg_15m, :decimal
    add_column :nodes, :disk_root_used_mb, :bigint
    add_column :nodes, :disk_root_total_mb, :bigint
    add_column :nodes, :disk_zfs_used_mb, :bigint
    add_column :nodes, :disk_zfs_total_mb, :bigint
  end
end
