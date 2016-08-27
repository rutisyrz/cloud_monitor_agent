class AwsApiHelper	

	def initialize(method, service, service_action, arguments)		
		@method = method
		@service = service
		@service_action = service_action
		@arguments = arguments
	end

	def send_request		
		begin
			result = RestClient::Request.execute(
								method: @method.to_sym, 
								url: "#{ENV["AWS_API_ENDPOINT"]}/#{@service}/#{@service_action}",
								timeout: 10, 
								headers: 
								{
									params: {
										server_access_token: ENV['CLOUD_MONITOR_SERVER_ACCESS_TOKEN']
									}.merge!(@arguments)
								}
							)
			JSON.parse result
		rescue Exception => each

		end
	end

end