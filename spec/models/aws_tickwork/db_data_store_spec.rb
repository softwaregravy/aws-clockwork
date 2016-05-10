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

require 'rails_helper'

module AwsTickwork
  RSpec.describe DbDataStore, type: :model do
    describe "#set" do 
        it "creates a new record" do 
          expect {
            DbDataStore.set("myKey", 10)
          }.to change(DbDataStore, :count).by(1)
        end
        it "should save the value" do 
          DbDataStore.set("myKey", 10)
          DbDataStore.take.value.should == 10
        end
        it "should overwrite existing values" do 
          DbDataStore.set("myKey", 10)
          expect {
            DbDataStore.set("myKey", 20)
          }.not_to change(DbDataStore, :count)
        end
    end
    describe "#get" do 
      it "returns nil if doesn't exist" do 
        DbDataStore.get("myKey").should == nil
      end
      it "plays nicely with #set" do 
        DbDataStore.set("myKey", 10)
        DbDataStore.get("myKey").should == 10
      end
    end
    it "generally works" do 
      # if multiple tests are failing, fix this one last
      DbDataStore.set("A", 10)
      DbDataStore.set("B", 10)
      DbDataStore.get("C").should == nil
      DbDataStore.get("A").should == 10
      DbDataStore.get("B").should == 10
      DbDataStore.set("B", 20)
      DbDataStore.get("C").should == nil
      DbDataStore.get("A").should == 10
      DbDataStore.get("B").should == 20
    end
  end
end
