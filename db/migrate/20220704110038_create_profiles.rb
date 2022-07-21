class CreateProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :profiles do |t|
      t.string :name
      t.string :address
      t.string :phone_number
      t.datetime :birthday
      t.string :breeding_experience
      t.references :user

      t.timestamps
    end
  end
end
