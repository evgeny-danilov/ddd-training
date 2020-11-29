class CreateFlights < ActiveRecord::Migration[6.0]
  def change
    create_table :flights do |t|
      t.string :uuid, null: false
      t.references :route, null: false, foreign_key: true
      t.datetime :departure_at
      t.datetime :arrival_at

      t.timestamps
    end
  end
end
