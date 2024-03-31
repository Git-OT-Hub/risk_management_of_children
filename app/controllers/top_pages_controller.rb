class TopPagesController < ApplicationController
  skip_before_action :require_login, only: %i[top privacy_policy terms_of_service]

  def top
    @diagnosis_contents = DiagnosisContent.all
  end

  def privacy_policy; end

  def terms_of_service; end

end
