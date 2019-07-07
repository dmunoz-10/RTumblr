class CreateBlogs < ActiveRecord::Migration[5.2]
  def change
    create_table :blogs do |t|
      t.references :user, foreign_key: true
      t.string :name, null: false
      t.string :description

      t.timestamps
      t.datetime :deleted_at
    end
    add_index :blogs, :deleted_at
  end
end
