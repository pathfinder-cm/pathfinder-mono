namespace :scheduler do
  desc "Start the scheduler"
  task :start => :environment do
    deployment_scheduler = DeploymentScheduler.new
    container_scheduler = ContainerScheduler.new(
      limit_mem_threshold: ENV['SCHEDULER_MEMORY_THRESHOLD'].try(:to_i)
      limit_n_containers: ENV['SCHEDULER_N_CONTAINERS_LIMIT'].try(:to_i)
      limit_n_stateful_containers: ENV['SCHEDULER_N_STATEFUL_CONTAINERS_LIMIT'].try(:to_i)
    )

    loop do
      deployment_scheduler.schedule
      container_scheduler.schedule
      sleep(5.second)
    end
  end

  task :apply_dirty => :environment do
    deployment_scheduler = DeploymentScheduler.new(apply_dirty: true)
    deployment_scheduler.schedule
  end
end
