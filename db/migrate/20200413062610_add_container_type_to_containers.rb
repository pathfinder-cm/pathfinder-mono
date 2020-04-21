class AddContainerTypeToContainers < ActiveRecord::Migration[5.2]
  def change
    add_column :containers, :container_type, :string, null: false, default: Container.container_types[:stateful]
  end
end
