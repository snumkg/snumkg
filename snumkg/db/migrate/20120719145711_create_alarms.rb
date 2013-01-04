class CreateAlarms < ActiveRecord::Migration
  def change
    create_table :alarms do |t|
      t.integer :alarm_group_id
      t.integer :alarmer_id

      t.timestamps
    end
  end
end
