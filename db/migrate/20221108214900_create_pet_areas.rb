class CreatePetAreas < ActiveRecord::Migration[7.0]
  def change
    create_table :pet_areas do |t|
      t.references :pet, foreign_key: true
      t.references :area, foreign_key: true

      t.timestamps
    end

    add_index :pet_areas, [:pet_id, :area_id], unique: true
  end
end
