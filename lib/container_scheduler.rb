class ContainerScheduler
  def initialize
    @weight_stateful = ENV['SCHEDULER_STATEFUL_WEIGHT'] || 0
    @weight_mem_free_mb = ENV['SCHEDULER_MEM_FREE_MB_WEIGHT'] || 0
    @weight_mem_free_ratio = ENV['SCHEDULER_MEM_FREE_RATIO_WEIGHT'] || 0
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
    Node.where(cluster: container.cluster).first
  end
end
