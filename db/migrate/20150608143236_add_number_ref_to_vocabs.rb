class AddNumberRefToVocabs < ActiveRecord::Migration
  def change
    add_reference :vocabs, :number, index: true
  end
end
