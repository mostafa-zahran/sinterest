class AddUserTokenToUsers < ActiveRecord::Migration[5.0]
  def up
    add_column :users, :user_token, :string
  end

  def down
    remove_column :users, :user_token
  end
end
