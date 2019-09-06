class ChangeLoginName < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :login, :username
  end
end
