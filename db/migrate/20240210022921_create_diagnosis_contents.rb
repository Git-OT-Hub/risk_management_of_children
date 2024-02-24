class CreateDiagnosisContents < ActiveRecord::Migration[7.1]
  def change
    create_table :diagnosis_contents do |t|
      t.integer :number,               null: false
      t.string :title,                 null: false
      t.string :image
      t.text :dangers
      t.string :item_names
      t.text :item_descriptions
      t.text :item_points
      t.text :rakuten_item_image_urls
      t.text :rakuten_item_urls
      t.text :rakuten_item_texts

      t.timestamps
    end

    add_index :diagnosis_contents, :number, unique: true
  end
end
