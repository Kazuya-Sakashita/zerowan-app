class CreateCharacters < ActiveRecord::Migration[7.0]
  def change
    create_table :characters do |t|
      t.text :label

      t.timestamps
    end
  end
end
