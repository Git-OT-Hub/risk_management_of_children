class DiagnosisResultsController < ApplicationController

  def show
    @diagnosis = current_user.diagnosis_results.find(params[:id])
    @results = DiagnosisContent.where(number: @diagnosis.results)
    
  end
end
