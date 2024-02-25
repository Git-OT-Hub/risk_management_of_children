class CreateDiagnosisResults < ActiveRecord::Migration[7.1]
  def change
    create_table :diagnosis_results do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :results
      t.text :statuses

      t.timestamps
    end
  end
end
