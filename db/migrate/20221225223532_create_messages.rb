class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.references :room
      t.references :user
      t.text :body

      t.timestamps
    end
  end
end
