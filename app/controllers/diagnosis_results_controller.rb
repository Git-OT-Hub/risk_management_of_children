class DiagnosisResultsController < ApplicationController
  before_action :set_diagnosis, only: %i[show edit update destroy cancel_edit]

  def show
    @results = DiagnosisContent.where(number: @diagnosis.results)
  end

  def edit
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("diagnosis_result_#{@diagnosis.id}", partial: "form", locals: { diagnosis_result: @diagnosis }) }
      format.html {  }
    end
  end

  def update
    if @diagnosis.update(diagnosis_result_params)
      respond_to do |format|
        format.turbo_stream do
          flash.now[:success] = t("defaults.message.updated", item: DiagnosisResult.human_attribute_name(:title))
          render turbo_stream: [
            turbo_stream.replace("diagnosis_result_#{@diagnosis.id}", partial: "title", locals: { diagnosis: @diagnosis }),
            turbo_stream.update("flash_message", partial: "shared/flash_message")
          ]
        end
        format.html {  }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          flash.now[:danger] = t("defaults.message.not_updated", item: DiagnosisResult.human_attribute_name(:title))
          render turbo_stream: [
            turbo_stream.replace("diagnosis_result_#{@diagnosis.id}", partial: "form", locals: { diagnosis_result: @diagnosis }),
            turbo_stream.update("flash_message", partial: "shared/flash_message")
          ]
        end
        format.html {  }
      end
    end
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

  def cancel_edit
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("diagnosis_result_#{@diagnosis.id}", partial: "title", locals: { diagnosis: @diagnosis }) }
      format.html {  }
    end
  end

  private

  def set_diagnosis
    @diagnosis = current_user.diagnosis_results.find(params[:id])
  end

  def diagnosis_result_params
    params.require(:diagnosis_result).permit(:title)
  end
end
