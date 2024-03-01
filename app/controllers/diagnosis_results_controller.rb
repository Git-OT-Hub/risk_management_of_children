class DiagnosisResultsController < ApplicationController
  before_action :set_diagnosis, only: %i[show destroy]

  def show
    @results = DiagnosisContent.where(number: @diagnosis.results)
  end

  def destroy
    @diagnosis.destroy!
    respond_to do |format|
      if params[:redirect_after_delete] == "true"
        format.html { redirect_to my_page_path, success: t("defaults.message.deleted", item: DiagnosisResult.model_name.human), status: :see_other }
      else
        #format.turbo_stream { flash.now[:success] = t("defaults.message.deleted", item: DiagnosisResult.model_name.human) }
      end
    end
  end

  private

  def set_diagnosis
    @diagnosis = current_user.diagnosis_results.find(params[:id])
  end
end
