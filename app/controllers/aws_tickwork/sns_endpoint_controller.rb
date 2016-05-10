require_dependency "aws_tickwork/application_controller"
require 'rest-client'
require 'tickwork'

module AwsTickwork
  class SnsEndpointController < ApplicationController
    before_action :log_raw_post
    before_action :verify_aws_signature

    def notify
      body = JSON.parse(request.raw_post)
      # TODO verify aws signature
      if body["Type"] == "SubscriptionConfirmation"
        handle_subscription_confirmation(body)
      elsif body["Type"] == "Notification"
        handle_notification(body)
      end

      head :ok
    end

    protected
    def handle_notification(body)
      Tickwork.run
    end

    def handle_subscription_confirmation(body)
      url = body["SubscribeURL"]
      return unless url.present?
      begin
        RestClient.get url
      rescue => e
        #TODO what exception come here?
        raise 
      end
    end

    def log_raw_post
      Rails.logger.info request.raw_post
    end

    def verify_aws_signature
      verifier = Aws::SNS::MessageVerifier.new
      unless verifier.authentic?(request.raw_post)
        head :unauthorized and return false
      end
      true
    end
  end
end
