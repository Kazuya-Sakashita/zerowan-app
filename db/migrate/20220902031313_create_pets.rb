class CreatePets < ActiveRecord::Migration[7.0]
  def change
    create_table :pets do |t|
      t.integer :category, index: true
      t.string :petname
      t.text :introduction
      t.integer :gender, null: false, default: 0, index: true
      t.integer :age, null: false, default: 0, index: true
      t.integer :classification, null: false, default: 0, index: true
      t.integer :castration, null: false, default: 0
      t.integer :vaccination, null: false, default: 0
      t.integer :recruitment_status, null: false, default: 0
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
