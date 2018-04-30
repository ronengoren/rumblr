class User < ActiveRecord::Base
      has_many :posts, dependent: :destroy
      validates :email, :uniqueness => true
      validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create

end
