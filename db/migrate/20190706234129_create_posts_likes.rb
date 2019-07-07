class CreatePostsLikes < ActiveRecord::Migration[5.2]
  def change
    create_table :posts_likes do |t|
      t.references :user, foreign_key: true
      t.references :post, foreign_key: true

      t.timestamps
      t.datetime :deleted_at
    end
    add_index :posts_likes, :deleted_at
  end
end
