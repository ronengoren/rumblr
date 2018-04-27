class Post < ActiveRecord::Base
  belongs_to :user
  has_many :taggedposts
  has_many :tags, through: :taggedposts



end
