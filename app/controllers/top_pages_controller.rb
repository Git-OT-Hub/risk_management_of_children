class TopPagesController < ApplicationController
  skip_before_action :require_login, only: %i[top privacy_policy]

  def top
    @diagnosis_contents = DiagnosisContent.all
  end

  def privacy_policy; end
end
