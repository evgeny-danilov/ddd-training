class AddFlightUuidToSeatReservation < ActiveRecord::Migration[6.0]
  def change
    add_column :seat_reservations, :flight_uuid, :string
    add_index :seat_reservations, :flight_uuid
  end
end
