Gem.loaded_specs['aws_tickwork'].dependencies.select {|g| g.type == :runtime }.each do |d|
  require d.name
end

require 'aws_tickwork/engine'

module AwsTickwork
  class Engine < ::Rails::Engine
    class ValidationError < RuntimeError; end
    isolate_namespace AwsTickwork

    class << self
      mattr_accessor :https_only, :http_username, :http_password, :enable_authenticate
      self.https_only = false
      self.enable_authenticate = true
    end

    def self.setup(&block)
      yield self
      validate_config(self)
    end

    def self.validate_config(config)
      unless http_password.present? == http_username.present?
        raise AwsTickwork::Engine::ValidationError.new 'http_password requires http_user, and visa versa'
      end
      if http_username.present? && !https_only
        raise AwsTickwork::Engine::ValidationError.new 'use only https with authentication or else the password is sent in the clear'
      end
    end

    config.generators do |g|
      g.test_framework :rspec, fixture: false
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.assets false
      g.helper false
    end


    def self.clear!
      self.https_only = false
      self.enable_authenticate = true
      self.http_username = nil
      self.http_password = nil
    end
  end
end
