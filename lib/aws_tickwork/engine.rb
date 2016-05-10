Gem.loaded_specs['aws_tickwork'].dependencies.each do |d|
   require d.name
end

require 'aws_tickwork/engine'

module AwsTickwork
  class Engine < ::Rails::Engine
    isolate_namespace AwsTickwork

    config.generators do |g|
      g.test_framework :rspec, fixture: false
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.assets false
      g.helper false
    end

  end
end
