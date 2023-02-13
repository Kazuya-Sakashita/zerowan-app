class CreateRooms < ActiveRecord::Migration[7.0]
  def change
    create_table :rooms do |t|
      t.references :user, null: false, foreign_key: true
      t.references :owner, null: false, foreign_key: { to_table: :users }
      t.references :pet, null: false, foreign_key: true
      t.integer :recruitment_status, null: false, default: 0
      t.timestamps
    end
    add_index :rooms, [:user_id, :owner_id, :pet_id], unique: true
  end
end
