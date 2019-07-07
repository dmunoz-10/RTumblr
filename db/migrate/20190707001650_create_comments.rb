class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.references :post, foreign_key: true
      t.references :user, foreign_key: true
      t.text       :body, null: false
      t.integer    :likes, default: 0, null: false

      t.timestamps
      t.datetime :deleted_at
    end
    add_index :comments, :deleted_at
  end
end
