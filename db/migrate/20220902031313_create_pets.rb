class CreatePets < ActiveRecord::Migration[7.0]
  def change
    create_table :pets do |t|
      t.integer :category
      t.string :name
      t.text :introduction
      t.integer :gender
      t.integer :age
      t.integer :classification
      t.integer :castration
      t.integer :vaccination
      t.integer :recruitment_status
      t.references :user

      t.timestamps
    end
  end
end
