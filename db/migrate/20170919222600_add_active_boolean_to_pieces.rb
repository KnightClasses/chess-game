class AddActiveBooleanToPieces < ActiveRecord::Migration[5.0]
  def change
    add_column :pieces, :active, :boolean, default: true
  end
end
