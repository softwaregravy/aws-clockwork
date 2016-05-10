# == Schema Information
#
# Table name: aws_tickwork_data_stores
#
#  id         :integer          not null, primary key
#  key        :string           not null
#  value      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :aws_tickwork_data_store, class: 'AwsTickwork::DataStore' do
    key "MyString"
    value 1
  end
end
