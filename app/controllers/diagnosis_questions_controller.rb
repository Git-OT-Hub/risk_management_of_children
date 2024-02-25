class DiagnosisQuestionsController < ApplicationController
  skip_before_action :require_login, only: %i[index calculate result]

  def index
    @diagnosis_questions = DiagnosisQuestion.all
  end

  def calculate
    answers = calculate_params.values
    if answers
      session[:answers] = answers
      redirect_to result_diagnosis_questions_path
    else
      redirect_to root_path, danger: t(".fail")
    end
  end

  def result
    answers = session[:answers]
    if answers
      @filtered_answers = answers.reject { |answer| answer == "no" || answer == "neither" }
      matched_contents = DiagnosisContent.where(number: @filtered_answers)
      @results = matched_contents
      session.delete(:answers)
    else
      redirect_to root_path, danger: t(".fail")
    end
  end

  private

  def calculate_params
    params.require(:calculate).permit(:answer_1, :answer_2, :answer_3, :answer_4, :answer_5, :answer_6, :answer_7, :answer_8, :answer_9, :answer_10, :answer_11, :answer_12, :answer_13, :answer_14, :answer_15)
  end
end
