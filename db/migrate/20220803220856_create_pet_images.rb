class CreatePetImages < ActiveRecord::Migration[7.0]
  def change
    create_table :pet_images do |t|
      t.references :pet
      t.string :image

      t.timestamps
    end
  end
end
