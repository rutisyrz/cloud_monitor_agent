module AppServersHelper
	def statuses
		AppServer::STATUSES.map {|s| [s, s]}
	end
end
