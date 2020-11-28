class CreateRoute < ActiveRecord::Migration[6.0]
  def change
    create_table :routes do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :airline, null: false, index: true
      t.time :departure_at, null: false
      t.time :arrival_at, null: false

      t.timestamps
    end
  end
end
