class AlterUsersAddUserIdAndUsernameColumns < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :user_id, :integer
    add_index :users, :user_id
    add_column :users, :username, :string
  end
end
