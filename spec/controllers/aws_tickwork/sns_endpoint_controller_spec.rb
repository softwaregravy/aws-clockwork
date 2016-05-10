require 'rails_helper'

RSpec.describe AwsTickwork::SnsEndpointController do 
  routes { AwsTickwork::Engine.routes }
  let(:subscription_confirmation_body) { <<-END.squish }
      { 
        "Type" : "SubscriptionConfirmation",
        "MessageId" : "bec4717a-b9c0-4e26-b8a1-687e624f5c5b",
        "Token" : "2336412f37fb687f5d51e6e241d44a2cb136210ba5740edb1677bedf5b391f309278d834dd116c60cc79f83cd406f74a72fdcd59e1a0440811f2b4772e9a91e01a0777dc0bf63e351b0af514d3bf5dc583f9fcbef3b1bee87a7081b16f0524807e9f6abf67a7378fba68bac711e8c830d7ad7e86c51059bae43780296dfdb228",
        "TopicArn" : "arn:aws:sns:us-east-1:372178782529:Lancaster-Staging",
        "Message" : "You have chosen to subscribe to the topic arn:aws:sns:us-east-1:372178782529:Lancaster-Staging.\nTo confirm the subscription, visit the SubscribeURL included in this message.",
        "SubscribeURL" : "https://sns.us-east-1.amazonaws.com/?Action=ConfirmSubscription&TopicArn=arn:aws:sns:us-east-1:372178782529:Lancaster-Staging&Token=2336412f37fb687f5d51e6e241d44a2cb136210ba5740edb1677bedf5b391f309278d834dd116c60cc79f83cd406f74a72fdcd59e1a0440811f2b4772e9a91e01a0777dc0bf63e351b0af514d3bf5dc583f9fcbef3b1bee87a7081b16f0524807e9f6abf67a7378fba68bac711e8c830d7ad7e86c51059bae43780296dfdb228",
        "Timestamp" : "2016-05-08T17:43:51.780Z",
        "SignatureVersion" : "1",
        "Signature" : "QOq0trJAXigt6v71lCqYdmv4DKYT/fAuWijUz7UHYTfSYrKl3CXki0VCZmYMhkKVS3Ki4dgtZFA4MtrB9XQindyQgcKuWQZo1/7Ena4I33lKpqkOEV8F/RiFCfFnpYxBF57Rv0mV1Z0fhbAAsxAMLoYFIq78U0eai74n0GD6kucK5sN4Bcr5VguZYoTsEXMZyA5eZItP0YN2QEUC/yh0SjuC/AkKv/wohV8jJr+K9tqva+zPWzgWpNLouGJ6PGfbSH+5nrxSqKvrT9JMiq3cqdyVVXl3Ds3KGki6/ZAb6c4UZGI3Pup+7DO68Ep8DPjMEhtnd5K+HZIVBWbmEEoB2g==", 
        "SigningCertURL" : "https://sns.us-east-1.amazonaws.com/SimpleNotificationService-bb750dd426d95ee9390147a5624348ee.pem"
      }
      END
  let (:notification_body) { <<-END.squish }
      {
        "Type" : "Notification",
        "MessageId" : "36313258-6c80-508f-a5ae-7df1cb7989f4",
        "TopicArn" : "arn:aws:sns:us-east-1:372178782529:Lancaster-Staging",
        "Message" : "{\\"version\\":\\"0\\",\\"id\\":\\"5f548e63-40c1-4558-bade-4afca3c44f79\\",\\"detail-type\\":\\"Scheduled Event\\",\\"source\\":\\"aws.events\\",\\"account\\":\\"372178782529\\",\\"time\\":\\"2016-05-08T20:46:47Z\\",\\"region\\":\\"us-east-1\\",\\"resources\\":[\\"arn:aws:events:us-east-1:372178782529:rule/MinutelyTester\\"],\\"detail\\":{}}",
        "Timestamp" : "2016-05-08T20:46:49.740Z",
        "SignatureVersion" : "1",
        "Signature" : "K7TXqlxTdmrlVObK4rLjPWDYqgf+2b6SITBPX3GNsSMizsr+A0UUG07kuCPTRnpLtVc0PHqgPq3qdqcV/TyraXFnxhxh6WA1gQyPgeoozpwFFQ8a+c0XsqZ8aPx35QV0eRUntY4HlAcB8bm5NSYK4c49ndyo0Yl013sjVyS/WDYWNWxQllhRMWvNrtl1ye95LNNMWL89RvNJLQpolYYpVb6me+9e+Y3u9eo9eg1KmTGg2C6f+IPJCHGPMgXNp0qzsl2lA4bZqQ+qwkGllvnq7JCTSZB5AJ+HmG/m8Q8TXEi5tcB8qGU70jaMdVl+Rrk7qzw0lfWPZ6y8Xf0fbhQ1oA==",
        "SigningCertURL" : "https://sns.us-east-1.amazonaws.com/SimpleNotificationService-bb750dd426d95ee9390147a5624348ee.pem",
        "UnsubscribeURL" : "https://sns.us-east-1.amazonaws.com/?Action=Unsubscribe&SubscriptionArn=arn:aws:sns:us-east-1:372178782529:Lancaster-Staging:44d97b9e-a40f-4a82-9077-ba24faec9227"
      }
    END
  let(:bad_type_body) { <<-END.squish }
      { 
          "Type" : "This is not a real type",
          "MessageId" : "bec4717a-b9c0-4e26-b8a1-687e624f5c5b",
          "Token" : "2336412f37fb687f5d51e6e241d44a2cb136210ba5740edb1677bedf5b391f309278d834dd116c60cc79f83cd406f74a72fdcd59e1a0440811f2b4772e9a91e01a0777dc0bf63e351b0af514d3bf5dc583f9fcbef3b1bee87a7081b16f0524807e9f6abf67a7378fba68bac711e8c830d7ad7e86c51059bae43780296dfdb228",
          "TopicArn" : "arn:aws:sns:us-east-1:372178782529:Lancaster-Staging",
          "Message" : "You have chosen to subscribe to the topic arn:aws:sns:us-east-1:372178782529:Lancaster-Staging.\nTo confirm the subscription, visit the SubscribeURL included in this message.",
          "SubscribeURL" : "https://sns.us-east-1.amazonaws.com/?Action=ConfirmSubscription&TopicArn=arn:aws:sns:us-east-1:372178782529:Lancaster-Staging&Token=2336412f37fb687f5d51e6e241d44a2cb136210ba5740edb1677bedf5b391f309278d834dd116c60cc79f83cd406f74a72fdcd59e1a0440811f2b4772e9a91e01a0777dc0bf63e351b0af514d3bf5dc583f9fcbef3b1bee87a7081b16f0524807e9f6abf67a7378fba68bac711e8c830d7ad7e86c51059bae43780296dfdb228",
          "Timestamp" : "2016-05-08T17:43:51.780Z",
          "SignatureVersion" : "1",
          "Signature" : "QOq0trJAXigt6v71lCqYdmv4DKYT/fAuWijUz7UHYTfSYrKl3CXki0VCZmYMhkKVS3Ki4dgtZFA4MtrB9XQindyQgcKuWQZo1/7Ena4I33lKpqkOEV8F/RiFCfFnpYxBF57Rv0mV1Z0fhbAAsxAMLoYFIq78U0eai74n0GD6kucK5sN4Bcr5VguZYoTsEXMZyA5eZItP0YN2QEUC/yh0SjuC/AkKv/wohV8jJr+K9tqva+zPWzgWpNLouGJ6PGfbSH+5nrxSqKvrT9JMiq3cqdyVVXl3Ds3KGki6/ZAb6c4UZGI3Pup+7DO68Ep8DPjMEhtnd5K+HZIVBWbmEEoB2g==", 
          "SigningCertURL" : "https://sns.us-east-1.amazonaws.com/SimpleNotificationService-bb750dd426d95ee9390147a5624348ee.pem"
        }
    END

    before do
      allow_any_instance_of(Aws::SNS::MessageVerifier).to receive(:authenticate!)
      allow_any_instance_of(Aws::SNS::MessageVerifier).to receive(:authentic?).and_return(true)
    end

  describe "#notify" do 
    describe "subscription_confirmation" do
      before do 
        @stub_get = stub_request(:get, "https://sns.us-east-1.amazonaws.com/?Action=ConfirmSubscription&Token=2336412f37fb687f5d51e6e241d44a2cb136210ba5740edb1677bedf5b391f309278d834dd116c60cc79f83cd406f74a72fdcd59e1a0440811f2b4772e9a91e01a0777dc0bf63e351b0af514d3bf5dc583f9fcbef3b1bee87a7081b16f0524807e9f6abf67a7378fba68bac711e8c830d7ad7e86c51059bae43780296dfdb228&TopicArn=arn:aws:sns:us-east-1:372178782529:Lancaster-Staging").
          with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => "", :headers => {})
      end
      it "responds ok" do 
        post :notify, subscription_confirmation_body
        response.should be_ok
      end
      it "confirms the subjscription" do 
        post :notify, subscription_confirmation_body
        assert_requested(@stub_get)
      end
      it "verifies the signature" do
        expect_any_instance_of(Aws::SNS::MessageVerifier).to receive(:authentic?).and_return(true)
        post :notify, subscription_confirmation_body
      end
    end
    describe "unrecognized" do 
      it "returns ok" do 
        post :notify, bad_type_body
        response.should be_ok
      end
    end
    describe "Notification" do 
      it "responds ok" do 
        post :notify, notification_body
        response.should be_ok
      end
      it "runs Tickwork" do 
        expect(Tickwork).to receive(:run)
        post :notify, notification_body
      end
      it "verifies the signature" do
        expect_any_instance_of(Aws::SNS::MessageVerifier).to receive(:authentic?)
        post :notify, notification_body
      end
      context "with an invalid signature" do 
        before { expect_any_instance_of(Aws::SNS::MessageVerifier).to receive(:authentic?).and_return(false) }
        it "should not call Tickwork" do 
          expect(Tickwork).not_to receive(:run)
          post :notify, notification_body
        end
      end
    end
  end 
end
