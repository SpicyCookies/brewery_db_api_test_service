class CreateSearches < ActiveRecord::Migration[6.0]
  def change
    create_table :searches do |t|
      t.string :state, null: true
      t.string :brewery_type, null: true
    end

    add_index :searches, [:state, :brewery_type], unique: true
  end
end
