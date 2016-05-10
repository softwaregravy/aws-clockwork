require_dependency "aws_tickwork/application_controller"
require 'rest-client'
require 'tickwork'

module AwsTickwork
  class SnsEndpointController < ApplicationController
    before_action :log_raw_post
    before_action :verify_aws_signature
    # not working, amazon hasn't implemented despite docs saying they have
    #before_action :my_http_authenticate

    def notify
      body = JSON.parse(request.raw_post)
      case message_type
      when "SubscriptionConfirmation"
        handle_subscription_confirmation(body)
      when "Notification"
        handle_notification(body)
      else
        # uncrecognized type or type missing
        Rails.logger.warn "Unrecognized message type: #{message_type}"
      end
      head :ok
    end

    protected

    def message_type
      request.headers["HTTP_X_AMZ_SNS_MESSAGE_TYPE"]
    end

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
      if AwsTickwork::Engine.enable_authenticate && !verifier.authentic?(request.raw_post)
        head :unauthorized 
        return false
      end
      true
    end

    # very close to method names in rails, give this a dumb one so we never have a conflict
    def my_http_authenticate
      if AwsTickwork::Engine.http_username.present? 
        authenticated = authenticate_with_http_basic do |username, password|
          AwsTickwork::Engine.username == username && AwsTickwork::Engine.password == password
        end
        unless authenticated
          head :unauthorized
          return false
        end
        true
      end
    end
  end
end
