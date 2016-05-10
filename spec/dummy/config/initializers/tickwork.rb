require 'tickwork'
module Tickwork
  configure do |config|
    config[:data_store] = AwsTickwork::DbDataStore
    config[:thread] = true
    config[:tick_size] = 60
    config[:max_ticks] = 10
    config[:max_catchup] = 3600
  end

  handler do |job|
    puts "Running #{job}"
  end

  every(1.minute, 'minutely.job')
  every(1.hour, 'hourly.job')
end
