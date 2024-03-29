class CreateCommentReplies < ActiveRecord::Migration[7.1]
  def change
    create_table :comment_replies do |t|
      t.text :body, null: false
      t.references :user, null: false, foreign_key: true
      t.references :comment, null: false, foreign_key: true
      t.references :parent, foreign_key: { to_table: :comment_replies }

      t.timestamps
    end
  end
end
