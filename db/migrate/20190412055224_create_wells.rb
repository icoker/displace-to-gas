class CreateWells < ActiveRecord::Migration[5.2]
  def change
    create_table :wells do |t|
      t.integer :toptvd
      t.integer :bottomtvd
      t.float :gasgradient
      t.integer :influxtvd
      t.integer :influxpressure
      t.timestamps
    end
  end
end
