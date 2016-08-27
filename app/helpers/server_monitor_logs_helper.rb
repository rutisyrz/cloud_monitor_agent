module ServerMonitorLogsHelper
	def report_options
		ServerMonitorLog::REPORTS.map {|r| [r, r]}
	end
end
