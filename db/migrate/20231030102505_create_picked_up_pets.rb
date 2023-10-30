class CreatePickedUpPets < ActiveRecord::Migration[7.0]
  def change
    create_table :picked_up_pets do |t|
      t.references :pet, null: false, foreign_key: true
      t.datetime :picked_up_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }

      t.timestamps
    end
  end
end
