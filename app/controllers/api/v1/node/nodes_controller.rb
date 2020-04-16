class ::Api::V1::Node::NodesController < ::Api::V1::Node::BaseController
  def store_metrics
    current_node.update_attributes(
      mem_free_mb: params[:memory][:free],
      mem_used_mb: params[:memory][:used],
      mem_total_mb: params[:memory][:total],

      load_capacity: params[:load][:capacity],
      load_avg_1m: params[:load][:load_avg_1m],
      load_avg_5m: params[:load][:load_avg_5m],
      load_avg_15m: params[:load][:load_avg_15m],

      disk_root_used_mb: params[:disk_root][:used],
      disk_root_total_mb: params[:disk_root][:total],

      disk_zfs_used_mb: params[:disk_zfs][:used],
      disk_zfs_total_mb: params[:disk_zfs][:total],
    )

    render json: ::Api::V1::Node::NodeSerializer.new(current_node).to_h
  end
end
