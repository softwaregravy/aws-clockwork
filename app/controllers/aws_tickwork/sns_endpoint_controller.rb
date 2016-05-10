require_dependency "aws_tickwork/application_controller"
require 'rest-client'
require 'tickwork'

module AwsTickwork
  class SnsEndpointController < ApplicationController
    before_action :log_raw_post
    before_action :verify_aws_signature
    before_action :authenticate
    force_ssl if AwsTickwork::Engine.https_only

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

    def log_raw_post
      Rails.logger.info request.raw_post
    end

    def message_type
      request.headers["HTTP_X_AMZ_SNS_MESSAGE_TYPE"]
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

    def handle_notification(body)
      Tickwork.run
    end

    def verify_aws_signature
      verifier = Aws::SNS::MessageVerifier.new
      if AwsTickwork::Engine.enable_authenticate && !verifier.authentic?(request.raw_post)
        head :unauthorized 
        return false
      end
      true
    end

    REALM = "SuperSecret"

    def authenticate
      if AwsTickwork::Engine.http_username.present? 
        auth_result = authenticate_or_request_with_http_digest(REALM) do |username|
          if username == AwsTickwork::Engine.http_username
            AwsTickwork::Engine.http_password
          end
        end
      end

    end
  end
end
