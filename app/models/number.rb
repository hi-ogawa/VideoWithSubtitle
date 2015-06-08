class Number < ActiveRecord::Base
  belongs_to :title
  has_many :vocabs
end
