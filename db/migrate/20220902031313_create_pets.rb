class CreatePets < ActiveRecord::Migration[7.0]
  def change
    create_table :pets do |t|
      t.integer :category
      t.string :petname
      t.text :introduction
      t.integer :gender, null: false, default: 0
      t.integer :age, null: false, default: 0
      t.integer :classification, null: false, default: 0
      t.integer :castration, null: false, default: 0
      t.integer :vaccination, null: false, default: 0
      t.integer :recruitment_status, null: false, default: 0
      t.references :user

      t.timestamps
    end
  end
end
