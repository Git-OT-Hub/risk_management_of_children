class CreateDiagnosisContents < ActiveRecord::Migration[7.1]
  def change
    create_table :diagnosis_contents do |t|
      t.integer :number,               null: false
      t.string :title,                 null: false
      t.text :danger
      t.string :item_name
      t.text :recommend
      t.string :rakuten_item_url
      t.string :rakuten_item_image_url

      t.timestamps
    end

    add_index :diagnosis_contents, :number, unique: true
  end
end
