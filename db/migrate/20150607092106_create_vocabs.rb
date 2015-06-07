class CreateVocabs < ActiveRecord::Migration
  def change
    create_table :vocabs do |t|
      t.string :title
      t.integer :season
      t.integer :episode
      t.string :word
      t.string :sentence
      t.string :picture

      t.timestamps
    end
  end
end
