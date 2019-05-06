class RenameImageToImageAlias < ActiveRecord::Migration[5.2]
  def change
    rename_column :containers, :image, :image_alias
  end
end
