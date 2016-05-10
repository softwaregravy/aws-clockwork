FactoryGirl.define do
  factory :aws_tickwork_active_record_data_store, class: 'AwsTickwork::ActiveRecordDataStore' do
    key "MyString"
    value 1
  end
end
