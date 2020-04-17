class ::Api::V1::Node::NodesController < ::Api::V1::Node::BaseController
  def store_metrics
    current_node.update_attributes(
      mem_free_mb: params.dig(:memory, :free),
      mem_used_mb: params.dig(:memory, :used),
      mem_total_mb: params.dig(:memory, :total),

      load_capacity: params.dig(:load, :capacity),
      load_avg_1m: params.dig(:load, :load_avg_1m),
      load_avg_5m: params.dig(:load, :load_avg_5m),
      load_avg_15m: params.dig(:load, :load_avg_15m),

      disk_root_used_mb: params.dig(:disk_root, :used),
      disk_root_total_mb: params.dig(:disk_root, :total),

      disk_zfs_used_mb: params.dig(:disk_zfs, :used),
      disk_zfs_total_mb: params.dig(:disk_zfs, :total),
    )

    render json: ::Api::V1::Node::NodeSerializer.new(current_node).to_h
  end
end
