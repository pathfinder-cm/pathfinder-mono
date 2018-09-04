class ::Api::V1::Node::NodesController < ::Api::V1::Node::BaseController
  def store_metrics
    current_node.update_attributes(
      mem_free_mb: params[:memory][:free],
      mem_used_mb: params[:memory][:used],
      mem_total_mb: params[:memory][:total]
    )

    render json: ::Api::V1::Node::NodeSerializer.new(current_node).to_h
  end
end
