class Tag  < ActiveRecord::Base
  has_many :taggedposts
  has_many :posts, through: :taggedposts
end
