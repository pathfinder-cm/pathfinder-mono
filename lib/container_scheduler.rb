class ContainerScheduler
  def initialize
  end

  def start!
    loop do
      p 'Scheduling Container...'

      @counter = 0
      Cluster.all.each do |cluster|
        containers = cluster.containers.
          where(status: 'PENDING').
          order(last_status_update_at: :asc)

        if ENV['NODE_SCHEDULING_TYPE'] == 'CONTAINER'
          find_based_on_container(containers, cluster)
        else
          find_based_on_ram(containers, cluster)
        end
      end

      p "#{@counter} container(s) scheduled."
      sleep(5.seconds)
    end
  end

  def find_based_on_container(containers, cluster)
    containers.each do |container|
      node = Node.
        select('nodes.id, nodes.hostname, COUNT(containers) AS containers_count').
        joins('LEFT OUTER JOIN containers ON nodes.id = containers.node_id AND containers.status IN (\'SCHEDULED\', \'PROVISIONED\')').
        where('nodes.cluster_id = ?', cluster.id).
        group('nodes.id, nodes.hostname').
        order('containers_count ASC').
        first
      schedule_container!(container, node)
      @counter += 1
    end
  end

  def find_based_on_ram(containers, cluster)
    node_ram_treshold = ENV['NODE_RAM_TRESHOLD'] || 80
    containers.each do |container|
      node = Node.
        select('nodes.id, nodes.hostname, ceil((nodes.mem_used_mb::decimal/nodes.mem_total_mb::decimal) * 100) AS mem_used_percentage').
        where('nodes.cluster_id = ? AND ceil((nodes.mem_used_mb::decimal/nodes.mem_total_mb::decimal) * 100) <= ?', cluster.id, node_ram_treshold).
        order('mem_used_percentage').
        first
      schedule_container!(container, node)
      @counter += 1
    end
  end

  def schedule_container!(container, node)
    ActiveRecord::Base.transaction do
      p "Schedule container #{container.hostname} in #{node.hostname}"
      container.update_attribute(:node_id, node.id)
      container.update_status('SCHEDULED')
    end
  end
end
