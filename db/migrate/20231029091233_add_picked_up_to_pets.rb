class AddPickedUpToPets < ActiveRecord::Migration[7.0]
  def change
    add_column :pets, :picked_up, :boolean
  end
end
