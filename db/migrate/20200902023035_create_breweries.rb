class CreateBreweries < ActiveRecord::Migration[6.0]
  def change
    create_table :breweries do |t|
      t.string :name, null: false
      t.string :state, null: false
      t.string :brewery_type, null: false

      t.belongs_to :search, null: false
    end
  end
end
