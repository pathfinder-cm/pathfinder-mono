class AddSourceIdToContainers < ActiveRecord::Migration[5.2]
  def change
    add_column :containers, :source_id, :integer
    add_foreign_key :containers, :sources
  end
end
