class Post < ActiveRecord::Base
  belongs_to :user
  has_many :taggedposts
  has_many :tags, through: :taggedposts

  validates :title, presence: true
  validates :content, presence: true

  def self.search(search)
  where("content ilike ?", "%#{search}%")
end

end
