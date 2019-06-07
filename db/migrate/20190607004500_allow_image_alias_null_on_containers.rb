class AllowImageAliasNullOnContainers < ActiveRecord::Migration[5.2]
  def change
    change_column :containers, :image_alias, :string, null: true
  end
end
