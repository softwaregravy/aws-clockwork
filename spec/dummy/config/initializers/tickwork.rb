require 'tickwork'
module Tickwork
  configure do |config|
    config[:data_store] = AwsTickwork::DbDataStore
    config[:thread] = false
    config[:tick_size] = 60
    config[:max_ticks] = 10
    config[:max_catchup] = 3600
  end

  handler do |job|
    Rails.cache.increment('tickwork_testing')
  end

  every(1.minute, 'minutely.job')
end
