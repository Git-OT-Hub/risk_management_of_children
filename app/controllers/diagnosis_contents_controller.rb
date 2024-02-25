class DiagnosisContentsController < ApplicationController
  skip_before_action :require_login, only: %i[show]

  def show
    @diagnosis_content = DiagnosisContent.find(params[:id])
  end
end
