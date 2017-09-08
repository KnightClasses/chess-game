class ChangeXyTypeInPieces < ActiveRecord::Migration[5.0]
  def change
    change_column :pieces, :x, 'integer USING CAST(x AS integer)'
    change_column :pieces, :y, 'integer USING CAST(y AS integer)'
  end
end
