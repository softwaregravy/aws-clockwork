require 'rails_helper'

describe AwsTickwork::Engine do 
  before { AwsTickwork::Engine.clear! }
  it "has good defauls" do
    AwsTickwork::Engine.https_only.should == false
    AwsTickwork::Engine.http_username.should == nil
    AwsTickwork::Engine.http_password.should == nil
    AwsTickwork::Engine.enable_authenticate.should == true
  end

  it "can be configured" do 
    AwsTickwork::Engine.setup do |c|
      c.https_only = true
      c.http_username = "john"
      c.http_password = "password"
      c.enable_authenticate = false
    end
    AwsTickwork::Engine.https_only.should == true
    AwsTickwork::Engine.http_username.should == "john"
    AwsTickwork::Engine.http_password.should == "password"
    AwsTickwork::Engine.enable_authenticate.should == false
  end

  it "username required if password supplied" do 
    expect {
      AwsTickwork::Engine.setup do |c|
        c.https_only = true
        c.http_password = "password"
      end
    }.to raise_error AwsTickwork::Engine::ValidationError
  end

  it "refuses to send passwords in the clear" do 
    expect {
      AwsTickwork::Engine.setup do |c|
        c.https_only = false
        c.http_username = "john"
        c.http_password = "password"
      end
    }.to raise_error AwsTickwork::Engine::ValidationError
  end

end
