AWS Tickwork
===============

Combines  [Tickwork](https://github.com/softwaregravy/tickwork) with an SNS endpoint to let AWS drive your scheduling.

Install
==========

Gemfile
```
gem 'aws_tickwork'
```

routes.rb
```
mount AwsTickwork::Engine => "/aws_tickwork"
```

Tickwork can use any data store. It is compatible with `ActiveSupport::Cache::Store`. 
Note that for a distributed environment, you want a shared cache. 

AWS Tickwork provides support for an `ActiveRecord` implementation. To install the migrations:

```
rake aws_tickwork:install:migrations
rake db:migrate SCOPE=aws_tickwork
```

Create a tickwork.rb file. Lots of details in [Tickwork](https://github.com/softwaregravy/tickwork)
```
require 'tickwork'
module Tickwork
  configure do |config|
    # If using the provided ActiveRecord implementation
    config[:data_store] = AwsTickwork::DbDataStore
  end
  every(1.minutes, 'minutely.job') do 
    # something production
  end
end
```

Configure AWS
==============

We are using [CloudWatch Events](http://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide/WhatIsCloudWatchEvents.html) pushed to an [SNS Topic](http://docs.aws.amazon.com/sns/latest/dg/SendMessageToHttp.html) to drive our scheduler.

This works by:
* cloudwatch fires an event periodically (e.g. every 5 min)
* pushes event to SNS queue
* SNS pushes to HTTP/HTTPS endpoint, which is your rails app

To set this up:

1. Create an SNS topic: [SNS](https://console.aws.amazon.com/sns/v2/home?region=us-east-1)
2. Subscribe to your topic (for testing locally, I recommend [ngrok](https://ngrok.com/)). The default location for your endpoint is at `/aws_tickwork/sns_endpoint/notify`
3. Create a CloudWatch event rule which pushes to your endpoint [cloudwatch](https://console.aws.amazon.com/cloudwatch/home)

Uninstalling
===============

To remove only the aws_tickwork table
```
rake db:migrate SCOPE=aws_tickwork VERSION=0
```
