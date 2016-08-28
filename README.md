## Technology stack

> Rails 4.1.2
> Ruby 2.1.2
> MongoDB
> Phusion Passenger
> Nginx
> AWS (EC2, CloudWatch, ElasticIP, AMI)
> GitHub

## Repositories 

> cloud_monitor_agent
- git@github.com:rutisyrz/cloud_monitor_agent.git

> cloud_monitor_server
- git@github.com:rutisyrz/cloud_monitor_server.git

## Steps to prepare the source code

> Step - 1 : Configure cloud_monitor_agent app
- Bundle install
- Install and Run mongodb
- Replace AWS_REGION, AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY in config/application.yml with your AWS account credentials

> Step - 2 : Configure cloud_monitor_server app
	- Bundle install
	- Install and Run mongodb

## Steps to deploy 

> Step - 1 : Config app servers to deploy cloud_monitor_agent & cloud_monitor_server apps using Phusion Passenger and Nginx
	- References 
		- https://www.phusionpassenger.com/library/walkthroughs/deploy/ruby/aws/nginx/oss/launch_server.html
	- OS - UBUNTU 14.04
	- Configure one server, create it's AMI and use it to Configure another server to reduce time

> Step - 2 : Install MongoDB on UBUNTU 14.04
	- References 
		- http://tecadmin.net/install-mongodb-on-ubuntu/
		- https://www.digitalocean.com/community/tutorials/how-to-install-mongodb-on-ubuntu-14-04

> Step - 3 : Configure Perl scripts provided by AWS to populate Custom Metrics
	- References
		- http://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/mon-scripts.html
		- http://docs.aws.amazon.com/cli/latest/reference/cloudwatch/put-metric-data.html
	- AWS CloudWatch Custom Metrics pricing - https://aws.amazon.com/cloudwatch/pricing/
	- By doing this, we can collect data for Custom Metrics on AWS CloudWatch and we can use them for our application

> Step - 4 : Update cloud_monitor_server endpoint
	- Replace CLOUD_MONITOR_APP and CLOUD_MONITOR_SERVER_ACCESS_TOKEN in config/application.yml 

> Step - 5 : Register Agent App on Cloud Monito Server as a Client app
	- Link - CLOUD_MONITOR_SERVER_ACCESS_TOKEN/agents/new
	- On successful registration, it gives message show as below 
		"Congratulations! Your application has been successfully registered. 
		You can now access Cloud Monitor APIs using Server Access Token. 
		No need to pass AWS Access Key and AWS Secret Key in API requests."

> Step - 6 : Schedule a cron on cloud_monitor_agent server
	- cloud_monitor_agent app uses gem 'whenever' to manage crons
	- Reference - http://eewang.github.io/blog/2013/03/12/how-to-schedule-tasks-using-whenever/
	- Run command "whenever --update-crontab" on cloud_monitor_agent app server
