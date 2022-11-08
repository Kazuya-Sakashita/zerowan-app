class CreatePetAreas < ActiveRecord::Migration[7.0]
  def change
    create_table :pet_areas do |t|
      t.references :pet, foreign_key: true
      t.integer :area_id

      t.timestamps
    end
  end
end
