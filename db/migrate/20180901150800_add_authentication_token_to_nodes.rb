# frozen_string_literal: true

class AddAuthenticationTokenToNodes < ActiveRecord::Migration[5.2]
  def change
    add_column :nodes, :hashed_authentication_token, :string
    add_index :nodes, :hashed_authentication_token
    add_column :nodes, :authentication_token_generated_at, :datetime
  end
end
