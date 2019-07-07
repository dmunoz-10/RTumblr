class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      # User info
      t.string   :first_name
      t.string   :last_name
      t.string   :username
      t.string   :image
      t.integer  :gender
      t.string   :email
      t.string   :password_digest
      t.date     :birth_date
      t.string   :phone_number

      t.timestamps
      t.datetime :deleted_at
    end
    add_index :users, :deleted_at
  end
end
