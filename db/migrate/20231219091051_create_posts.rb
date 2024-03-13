class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.text :body
      t.references :user, foreign_key: true
      t.integer :favorites_count, default: 0
      t.integer :comments_count, default: 0

      t.timestamps
    end
  end
end
