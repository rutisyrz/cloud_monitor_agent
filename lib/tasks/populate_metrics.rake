desc "Populate metric"
task :populate_metrics => :environment do
  ServerMonitorLog.populate_metrics
end