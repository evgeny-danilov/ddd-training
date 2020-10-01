class CreateSeatReservation < ActiveRecord::Migration[6.0]
  def change
    create_table :seat_reservations do |t|
      t.integer :number
      t.string :flight_no
      t.string :event_id
    end
  end
end
