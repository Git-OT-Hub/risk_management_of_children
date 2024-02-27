class DiagnosisResultsController < ApplicationController

  def show
    @result = current_user.diagnosis_results.find(params[:id])
  end
end
