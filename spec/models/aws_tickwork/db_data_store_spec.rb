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
    describe "#write" do 
        it "creates a new record" do 
          expect {
            DbDataStore.write("myKey", 10)
          }.to change(DbDataStore, :count).by(1)
        end
        it "should save the value" do 
          DbDataStore.write("myKey", 10)
          DbDataStore.take.value.should == 10
        end
        it "should overwrite existing values" do 
          DbDataStore.write("myKey", 10)
          expect {
            DbDataStore.write("myKey", 20)
          }.not_to change(DbDataStore, :count)
        end
    end
    describe "#read" do 
      it "returns nil if doesn't exist" do 
        DbDataStore.read("myKey").should == nil
      end
      it "plays nicely with #write" do 
        DbDataStore.write("myKey", 10)
        DbDataStore.read("myKey").should == 10
      end
    end
    it "generally works" do 
      # if multiple tests are failing, fix this one last
      DbDataStore.write("A", 10)
      DbDataStore.write("B", 10)
      DbDataStore.read("C").should == nil
      DbDataStore.read("A").should == 10
      DbDataStore.read("B").should == 10
      DbDataStore.write("B", 20)
      DbDataStore.read("C").should == nil
      DbDataStore.read("A").should == 10
      DbDataStore.read("B").should == 20
    end
  end
end
