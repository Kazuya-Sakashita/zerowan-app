class CreateEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :entries do |t|
      t.references :user
      t.references :pet
      t.references :room
      t.integer :recruitment_status

      t.timestamps
    end
  end
end
