class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.text :players, array: true, default: []
      t.timestamps
    end
  end
end
