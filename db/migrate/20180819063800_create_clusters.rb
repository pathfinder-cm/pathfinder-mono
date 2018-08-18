# frozen_string_literal: true

class CreateClusters < ActiveRecord::Migration[5.2]
  def change
    create_table :clusters do |t|
      t.string  :name, null: false

      t.timestamps null: false
    end

    add_index :clusters, [:name], unique: true
  end
end
