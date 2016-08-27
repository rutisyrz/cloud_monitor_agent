class ServerMonitorLog
  include Mongoid::Document
  include Mongoid::Timestamps

  ## Note:
  # Mongoid::Timestamps adds fields created_at and updated_at
  # created_at can be used as Datapoint timestamp

  field :app_server_id, type: Integer
  field :cpu_usage, type: Float
  field :disk_usage_percent, type: Float  # stores result of DiskSpaceUtilization custom metric. Unit - %
  field :disk_usage_gb, type: Float # stores result of DiskSpaceUsed custom metric. Unit - Gigabytes
  field :process_running, type: Integer

  validates :app_server_id, presence: true
  
  belongs_to :app_server

  index( {app_server_id: 1}, {:background => true} )
  
  NAMESPACE_METRICS_COLLECTION = {"AWS/EC2" => ["CPUUtilization"], "System/Linux" => ["DiskSpaceUtilization", "DiskSpaceUsed"]}  
  ## Note:
  # Due to time constrain - I've hard coded REPORT_RECORD_LIMIT and REPORT_PERIOD instead of providing interface on dashboard
  REPORT_RECORD_LIMIT = 5
  REPORT_PERIOD = 3.hours
  REPORTS = ["cpu-high", "cpu-low", "disk-high", "disk-low"]

  class << self

    def fetch_log(params={})            
      if params[:report].present?        
        server_monitor_logs = case params[:report].downcase
                              when "cpu-high"
                                where("created_at" => {'$gt' => Time.now-REPORT_PERIOD}).order("cpu_usage DESC").limit(ServerMonitorLog::REPORT_RECORD_LIMIT).all
                              when "cpu-low"
                                where("created_at" => {'$gt' => Time.now-REPORT_PERIOD}).order("cpu_usage ASC").limit(REPORT_RECORD_LIMIT).all
                              when "disk-high"
                                where("created_at" => {'$gt' => Time.now-REPORT_PERIOD}).order("disk_usage_gb ASC").limit(REPORT_RECORD_LIMIT).all
                              when "disk-low"
                                where("created_at" => {'$gt' => Time.now-REPORT_PERIOD}).order("disk_usage_gb DESC").limit(REPORT_RECORD_LIMIT).all
                              end
      else
        server_monitor_logs = ServerMonitorLog.all.order("created_at DESC")
      end 
      server_monitor_logs  
    end

    def populate_metrics
      namespace_metrics = ServerMonitorLog::NAMESPACE_METRICS_COLLECTION.inject({}) {|result, (key, val)| val.each {|v| result[v] = key}; result }
      common_params = {start_time: Time.now-15.minutes, end_time: Time.now, period: 900}

      AppServer.running_instances.each do |app_server|
        metrics_stats = {}
        namespace_metrics.each do |metric, namespace|                    
          metric_params = send("#{metric.downcase}_api_params", app_server)
          metric_params.merge!(namespace: namespace, metric_name: metric).merge!(common_params)

          metrics_stats[metric] = AwsApiHelper.new("get", "cloud_watch", "statistics", metric_params).send_request
        end
        ServerMonitorLog.create(server_monitor_log_params(app_server, metrics_stats))          
      end
    end  

    def cpuutilization_api_params(app_server)
      {
        dimensions: "InstanceId^#{app_server.instance_id}",
        # [ { name: "InstanceId", value: app_server.instance_id } ],
        statistics: "Average", 
        unit: "Percent"
      }
    end

    def diskspaceutilization_api_params(app_server)
      {
        dimensions: "InstanceId^#{app_server.instance_id}|Filesystem^#{app_server.file_system}|MountPath^#{app_server.volume_mount_path}",
        # [ { name: "InstanceId", value: app_server.instance_id }, { name: "Filesystem", value: app_server.file_system },  {name: "MountPath", value: app_server.volume_mount_path} ], 
        statistics: "Average", 
        unit: "Percent"
      }
    end

    def diskspaceused_api_params(app_server)
      {
        dimensions: "InstanceId^#{app_server.instance_id}|Filesystem^#{app_server.file_system}|MountPath^#{app_server.volume_mount_path}",
        statistics: "Average",
        unit: "Gigabytes"
      }
    end

    def server_monitor_log_params(app_server, metrics_stats)
      {
        app_server_id: app_server.id,
        cpu_usage: metrics_stats["CPUUtilization"].present? && metrics_stats["CPUUtilization"]["result"].present? ? metrics_stats["CPUUtilization"]["result"].first["average"] : 0,
        disk_usage_percent: metrics_stats["DiskSpaceUtilization"].present? && metrics_stats["DiskSpaceUtilization"]["result"].present? ? metrics_stats["DiskSpaceUtilization"]["result"].first["average"] : 0,
        disk_usage_gb: metrics_stats["DiskSpaceUsed"].present? && metrics_stats["DiskSpaceUsed"]["result"].present? ? metrics_stats["DiskSpaceUsed"]["result"].first["average"] : 0
      }
    end

  end


end
