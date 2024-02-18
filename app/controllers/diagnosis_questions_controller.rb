class DiagnosisQuestionsController < ApplicationController
  skip_before_action :require_login, only: %i[index]

  def index
    @diagnosis_questions = DiagnosisQuestion.all
  end
end
