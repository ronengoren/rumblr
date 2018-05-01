class User < ActiveRecord::Base

      attr_accessor :user_id
      EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

      has_many :posts, dependent: :destroy
      validates :email, :presence => true, :uniqueness => true, :format => EMAIL_REGEX
      validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create
      validates_uniqueness_of :email, presence: {message: "That email is already associated to another account. Please use another email."}

end
