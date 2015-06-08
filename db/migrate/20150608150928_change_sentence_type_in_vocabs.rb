class ChangeSentenceTypeInVocabs < ActiveRecord::Migration
  def change
    change_column :vocabs, :sentence, :text
  end
end
