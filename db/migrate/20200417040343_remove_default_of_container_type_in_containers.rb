class RemoveDefaultOfContainerTypeInContainers < ActiveRecord::Migration[5.2]
  def change
    change_column_default :containers, :container_type, nil
  end
end
