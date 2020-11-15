class RenamePassengerTable < ActiveRecord::Migration[6.0]
  def change
    rename_table :passengers, :seat_reservation_passengers
  end
end
