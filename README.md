AWS Tickwork
===============

Combines  [Tickwork](https://github.com/softwaregravy/tickwork) with an SNS endpoint to let AWS drive your scheduling.

We use AWS Cloudwatch scheduled events to push notifications into SNS which in turn posts back to your app. This lets you run scheduled events without running a separate process.

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

Create a config/initializers/tickwork.rb file. Lots of details in [Tickwork](https://github.com/softwaregravy/tickwork)
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
Note: it's important this is an initalizer or else you have to configure it every time.

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
3. Create a CloudWatch event rule which pushes to your endpoint [cloudwatch](https://console.aws.amazon.com/cloudwatch/home). When you create the rule, choose `Schedule` as the event source and your SNS topic from step 2. I suggest every 5 min as a default if you're just getting going. It will play nicely with Tickwork defaults. 

Free Tier Reference
==============

[SNS Pricing](https://aws.amazon.com/sns/pricing/) sets out no charge for the first 100,000 HTTP calls per month, and then $0.60/million after that. Pretty cheap. Data Transfer is free to the first GB and $0.09/GB after that. These are empty messages, so should also be pretty cheap. 

30 days * 24 hours * 60 minutes = 43,200

So if you set up you were to configure your Cloudwatch event clock to fire every minute, you can basically run 2 apps full time for free.

Uninstalling
===============

To remove only the aws_tickwork table
```
rake db:migrate SCOPE=aws_tickwork VERSION=0
```

Clean up your SNS topic and Cloudwatch Event in AWS.

Motivation
==============

I was running an app on Heroku and upgraded to the hobby plan. $7/month for a dyno and all that dyno does is run a scheduler? what am I? made of money?  That's right. I built this to save money on background dynos. 
