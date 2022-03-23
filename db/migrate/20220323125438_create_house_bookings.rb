class CreateHouseBookings < ActiveRecord::Migration[6.0]
  def change
    create_table :house_bookings do |t|
      t.references(:house, null: false, foreign_key: true)
      t.date(:check_in)
      t.date(:check_out)

      t.timestamps
    end
  end
end
