class CreatePostsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
     t.integer :user_id
     t.string :title
     t.string :content
     t.datetime :created_at
   end
  end
end
