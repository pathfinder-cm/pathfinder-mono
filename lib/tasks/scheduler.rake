namespace :scheduler do
  desc "Start the scheduler"
  task :start => :environment do
    deployment_scheduler = DeploymentScheduler.new
    container_scheduler = ContainerScheduler.new

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
