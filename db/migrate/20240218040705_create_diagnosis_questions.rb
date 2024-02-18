class CreateDiagnosisQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :diagnosis_questions do |t|
      t.integer :diagnosis_content_number, null: false
      t.text :body,                        null: false

      t.timestamps
    end

    add_index :diagnosis_questions, :diagnosis_content_number, unique: true
  end
end
