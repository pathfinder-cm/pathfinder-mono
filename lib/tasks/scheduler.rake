namespace :scheduler do
  desc "Start the scheduler"
  task :start => :environment do
    container_scheduler = ContainerScheduler.new
    container_scheduler.start!
  end
end
