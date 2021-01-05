class AddStatusToFlight < ActiveRecord::Migration[6.0]
  def change
    add_column :flights, :status, :string
    add_index :flights, :status
  end
end
