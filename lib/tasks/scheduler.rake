namespace :scheduler do
  desc "Start the scheduler"
  task :start => :environment do
    container_scheduler = ContainerScheduler.new

    loop do
      container_scheduler.schedule
      sleep(5.second)
    end
  end
end
