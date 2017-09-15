class FixColumnName < ActiveRecord::Migration[5.0]
  def change
    rename_column :pieces, :type, :role
  end

end
