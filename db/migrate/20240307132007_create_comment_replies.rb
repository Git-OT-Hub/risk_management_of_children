class CreateCommentReplies < ActiveRecord::Migration[7.1]
  def change
    create_table :comment_replies do |t|
      t.text :body, null: false
      t.references :user, null: false, foreign_key: true
      t.references :comment, null: false, foreign_key: true
      t.text :user_ids

      t.timestamps
    end
  end
end
