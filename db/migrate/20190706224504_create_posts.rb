class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.references :blog, foreign_key: true
      t.text       :body, null: false
      t.integer    :visits, default: 0, null: false
      t.integer    :likes, default: 0, null: false
      t.boolean    :private, null: false

      t.timestamps
      t.datetime :deleted_at
    end
    add_index :posts, :deleted_at
  end
end
