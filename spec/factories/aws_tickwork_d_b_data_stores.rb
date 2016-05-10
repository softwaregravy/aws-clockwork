FactoryGirl.define do
  factory :aws_tickwork_d_b_data_store, class: 'AwsTickwork::DBDataStore' do
    key "MyString"
    value 1
  end
end
