# frozen_string_literal: true

class RemoveHostnameUniquenessOnContainers < ActiveRecord::Migration[5.2]
  def change
    remove_index :containers, [:cluster_id, :hostname]
    add_index :containers, [:cluster_id, :hostname]
  end
end
