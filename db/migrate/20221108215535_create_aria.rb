class CreateAria < ActiveRecord::Migration[7.0]
  def change
    create_table :aria do |t|
      t.string :place_name

      t.timestamps
    end
  end
end
