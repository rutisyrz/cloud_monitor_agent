# cloud_monitor_agent
Client app to integrate REST APIs of cloud_monitor_server 

## Required Gems

- [aws-sdk](https://rubygems.org/gems/aws-sdk), [mongoid](https://rubygems.org/gems/mongoid), [bson_ext](https://rubygems.org/gems/bson_ext), [figaro](https://rubygems.org/gems/figaro)

## Prerequisite

- This app uses REST APIs designed in my another app [cloud_monitor_server](https://github.com/rutisyrz/cloud_monitor_server)
- Hence, configur [cloud_monitor_server](https://github.com/rutisyrz/cloud_monitor_server) as per details provided

## Setup code

- Install bundle
```ruby
$ bundle install
```
- Add your AWS account details in file */config/application.yml* which can be used while initializing AWS config in file */config/initializer/aws.rb*
```ruby
Aws.config.update({
	region: ENV['AWS_REGION'],
  credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])
})
```
- Replace *CLOUD_MONITOR_APP* and *CLOUD_MONITOR_SERVER_ACCESS_TOKEN* in */config/application.yml* as per details defined by you while configuring [cloud_monitor_server](https://github.com/rutisyrz/cloud_monitor_server) app
- Set frequency of a cron to fetch **Custom Metrics** data from AWS CloudWatch in */config/schedule.rb*
```ruby
every 15.minutes do 
	rake 'populate_metrics'
end
```
- Install MongoDB on Mac OS
```shell
$ brew install mongodb
```
- Install MongoDB on Ubuntu
```shell
$ sudo apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
$ sudo echo "deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen" | tee -a /etc/apt/sources.list.d/10gen.list
$ sudo apt-get -y update
$ sudo apt-get install mongodb-org
```
- Verify MongoDB installation 
```shell
$ mongod --version
```
- Check status of MongoDB
```shell
$ service mongod status
```
- **Note:** By default starts running after installation on port=27017 *http://localhost:27017/*
- Start/Stop MongoDB
```shell
$ sudo service mongod start
$ sudo service mongod stop
```
- Run rails app on port=3000
```ruby
$ rails s
```
- Run command "*whenever --update-crontab*" to schedule cron on server


