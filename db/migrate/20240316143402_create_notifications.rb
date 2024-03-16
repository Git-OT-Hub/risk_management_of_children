class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.references :sender, null: false, foreign_key: { to_table: :users }
      t.references :recipient, null: false, foreign_key: { to_table: :users }
      t.references :notifiable, polymorphic: true
      t.string :action, null: false, default: ""
      t.boolean :read, null: false, default: false

      t.timestamps
    end
  end
end
