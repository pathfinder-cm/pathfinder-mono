class RenameTypeToSourceTypeOnSources < ActiveRecord::Migration[5.2]
  def change
    rename_column :sources, :type, :source_type
  end
end
