class AddImageServerAndProtocolToContainers < ActiveRecord::Migration[5.2]
  def change
    add_column :containers, :image_server, :string
    add_column :containers, :image_protocol, :string
  end
end
