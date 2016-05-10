# == Schema Information
#
# Table name: aws_tickwork_db_data_stores
#
#  id         :integer          not null, primary key
#  key        :string           not null
#  value      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

module AwsTickwork
  class DbDataStore < ActiveRecord::Base
    class << self
      def get(key)
        DbDataStore.where(key: key).take&.value
      end
      def set(key, value)
        DbDataStore.find_or_initialize_by(key: key).update_attributes!(value: value)
      end
    end
  end
end
