class RemoveImageServerFromContainers < ActiveRecord::Migration[5.2]
  def up
    if Container.where.not(image_server: nil).empty?
      remove_column :containers, :image_server, :string
    else
      raise "There is Container that has image_server value"
    end
  end

  def down
    add_column :containers, :image_server, :string
  end
end
