class RemoveImageProtocolFromContainers < ActiveRecord::Migration[5.2]
  def up
    if Container.where.not(image_protocol: nil).empty?
      remove_column :containers, :image_protocol, :string
    else
      raise "There is Container that has image_protocol value"
    end
  end

  def down
    add_column :containers, :image_protocol, :string
  end
end
