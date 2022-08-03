class CreatePetCharacters < ActiveRecord::Migration[7.0]
  def change
    create_table :pet_characters do |t|
      t.references :pet
      t.integer :character_id

      t.timestamps
    end
  end
end
