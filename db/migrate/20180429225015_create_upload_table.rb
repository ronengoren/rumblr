class CreateUploadTable < ActiveRecord::Migration[5.2]
  def change
    create_table :uploads do |t|
    	t.integer "post_id"
    	t.string :image_url
  	end
  end
end
