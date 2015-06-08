class CreateNumbers < ActiveRecord::Migration
  def change
    create_table :numbers do |t|
      t.references :title, index: true
      t.integer :season
      t.integer :episode
    end
  end
end
