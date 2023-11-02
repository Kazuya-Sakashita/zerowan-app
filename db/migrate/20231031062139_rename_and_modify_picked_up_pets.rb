class RenameAndModifyPickedUpPets < ActiveRecord::Migration[7.0]
  def change
    # テーブル名を変更
    rename_table :picked_up_pets, :pickups

    # picked_up_atカラムを削除
    remove_column :pickups, :picked_up_at
  end
end
