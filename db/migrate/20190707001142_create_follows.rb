class CreateFollows < ActiveRecord::Migration[5.2]
  def change
    create_table :follows do |t|
      t.integer :leader_id
      t.integer :follower_id

      t.timestamps
      t.datetime :deleted_at
    end
    add_index :follows, :deleted_at
  end
end
