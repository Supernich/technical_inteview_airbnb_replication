class CreateHouses < ActiveRecord::Migration[6.0]
  def change
    create_table :houses do |t|
      t.string(:country)
      t.string(:city)
      t.string(:name)
      t.string(:description)
      t.string(:address)
      t.decimal(:price, precision: 12, scale: 2)

      t.timestamps
    end
  end
end
