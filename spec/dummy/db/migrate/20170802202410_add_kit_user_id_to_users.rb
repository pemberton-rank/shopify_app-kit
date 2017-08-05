class AddKitUserIdToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :kit_access_token, :string
    add_column :users, :kit_user_id, :string
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
  end
end
