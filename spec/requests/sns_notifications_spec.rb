
require 'rails_helper'

RSpec.describe "SNS driving tickwork events", type: :request do 
  before do
    allow_any_instance_of(Aws::SNS::MessageVerifier).to receive(:authenticate!)
    allow_any_instance_of(Aws::SNS::MessageVerifier).to receive(:authentic?).and_return(true)
  end
  let (:sample_notification) do 
    sample = <<-END
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
    sample.squish
  end
  it "causes a job to run" do 
    Rails.cache.write('tickwork_testing', 0)
    post "/aws_tickwork/sns_endpoint/notify", sample_notification
    response.should be_ok
    Rails.cache.read('tickwork_testing').should == 1

  end

end
