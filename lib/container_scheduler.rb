class ContainerScheduler
  def initialize(limit_mem_threshold: nil, limit_n_containers: nil, limit_n_stateful_containers: nil)
    @limit_mem_threshold = limit_mem_threshold
    @limit_n_containers = limit_n_containers
    @limit_n_stateful_containers = limit_n_stateful_containers
  end

  def schedule
    n_containers = 0
    Container.pending.find_each do |container|
      schedule_container(container)
      n_containers += 1
    end

    p "#{n_containers} container(s) scheduled."
  end

  def schedule_container(container)
    node = find_best_node(container)
    return if node.nil?

    ActiveRecord::Base.transaction do
      container.update_attribute(:node_id, node.id)
      container.update_status(Container.statuses[:scheduled])
    end
  end

  def find_best_node(container)
    nodes = Node.
      where(cluster: container.cluster).
      joins("LEFT OUTER JOIN containers ON nodes.id = containers.node_id AND containers.status NOT IN ('SCHEDULE_DELETION', 'DELETED')").
      group("nodes.id")

    nodes = nodes.where(
      "ceil(CASE WHEN (nodes.mem_used_mb::decimal/nodes.mem_total_mb::decimal) IS NULL " \
      "THEN 1 " \
      "ELSE (nodes.mem_used_mb::decimal/nodes.mem_total_mb::decimal) END * 100) <= ?",
      @limit_mem_threshold
    ) unless @limit_mem_threshold.nil?
    nodes = nodes.having("COUNT(containers) <= ?", @limit_n_containers) unless @limit_n_containers.nil?
    nodes = nodes.having(
      "COUNT(containers) FILTER (WHERE container_type = 'STATEFUL') <= ?", @limit_n_stateful_containers
    ) unless @limit_n_stateful_containers.nil?

    nodes.first
  end
end
