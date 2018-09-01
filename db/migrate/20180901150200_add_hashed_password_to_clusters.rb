# frozen_string_literal: true

class AddHashedPasswordToClusters < ActiveRecord::Migration[5.2]
  def change
    add_column :clusters, :hashed_password, :string
    add_column :clusters, :password_updated_at, :datetime
  end
end
