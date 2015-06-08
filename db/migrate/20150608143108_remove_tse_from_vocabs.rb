class RemoveTseFromVocabs < ActiveRecord::Migration
  def change
    remove_column :vocabs, :title, :string
    remove_column :vocabs, :season, :integer
    remove_column :vocabs, :episode, :integer
  end
end
