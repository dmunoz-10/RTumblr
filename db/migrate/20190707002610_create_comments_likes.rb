class CreateCommentsLikes < ActiveRecord::Migration[5.2]
  def change
    create_table :comments_likes do |t|
      t.references :user, foreign_key: true
      t.references :comment, foreign_key: true

      t.timestamps
      t.datetime :deleted_at
    end
    add_index :comments_likes, :deleted_at
  end
end
