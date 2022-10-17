class CreatePetImages < ActiveRecord::Migration[7.0]
  def change
    create_table :pet_images do |t|
      t.string :photo
      t.references :pet, foreign_key: true


      t.timestamps
    end
  end
end
