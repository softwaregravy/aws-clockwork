class CreateAwsTickworkDbDataStores < ActiveRecord::Migration
  def change
    create_table :aws_tickwork_db_data_stores do |t|
      t.string :key, null: false
      t.integer :value

      t.timestamps null: false
    end
    add_index :aws_tickwork_db_data_stores, :key, unique: true
  end
end
