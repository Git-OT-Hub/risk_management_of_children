class CreateComments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments do |t|
      t.text :body, null: false
      t.references :user, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true
      t.integer :comment_replies_count, default: 0

      t.timestamps
    end
  end
end
