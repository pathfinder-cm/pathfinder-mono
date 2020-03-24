class ContainerScheduler
  def initialize
  end

  def schedule
    if ENV['SCHEDULER_TYPE'] == 'MEMORY'
      p 'Scheduling container based on node memory'
    else
      p 'Scheduling container based on node container numbers'
    end

    counter = 0
    Cluster.all.each { |cluster| counter += process_cluster(cluster) }

    p "#{counter} container(s) scheduled."
  end

  def process_cluster(cluster)
    pending_containers = cluster.containers.pending

    counter = 0
    pending_containers.each do |container|
      if ENV['SCHEDULER_TYPE'] == 'MEMORY'
        node = find_based_on_memory(cluster)
      else
        node = find_based_on_container_num(cluster)
      end

      unless node.nil?
        schedule_container!(container, node)
        counter += 1
      end
    end

    return counter
  end

  def schedule_container!(container, node)
    ActiveRecord::Base.transaction do
      p "Schedule container #{container.hostname} in #{node.hostname}"
      container.update_attribute(:node_id, node.id)
      container.update_status('SCHEDULED')
    end
  end

  private
    def find_based_on_container_num(cluster)
      Node.
        select('nodes.id, nodes.hostname, COUNT(containers) AS containers_count').
        joins('LEFT OUTER JOIN containers ON nodes.id = containers.node_id AND containers.status IN (\'SCHEDULED\', \'PROVISIONED\')').
        where('nodes.cluster_id = ?', cluster.id).
        group('nodes.id, nodes.hostname').
        order('containers_count ASC').
        first
    end

    def find_based_on_memory(cluster)
      memory_threshold = ENV['SCHEDULER_MEMORY_THRESHOLD'] || 50
      Node.
        select('nodes.id'\
          ', nodes.hostname'\
          ', COUNT(containers) AS containers_count'\
          ', ceil((nodes.mem_used_mb::decimal/nodes.mem_total_mb::decimal) * 100) AS mem_used_percentage').
        joins('LEFT OUTER JOIN containers'\
          ' ON nodes.id = containers.node_id'\
          ' AND containers.status IN (\'SCHEDULED\', \'PROVISIONED\')').
        where('nodes.cluster_id = ?'\
          ' AND ceil(CASE WHEN (nodes.mem_used_mb::decimal/nodes.mem_total_mb::decimal) IS NULL'\
          ' THEN 1'\
          ' ELSE (nodes.mem_used_mb::decimal/nodes.mem_total_mb::decimal) END * 100) <= ?',
          cluster.id, memory_threshold).
        group('nodes.id, nodes.hostname').
        order('containers_count ASC, mem_used_percentage ASC').
        first
    end
end
