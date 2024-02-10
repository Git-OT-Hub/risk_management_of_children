class TopPagesController < ApplicationController
  skip_before_action :require_login, only: %i[top]

  def top
    @diagnosis_contents = DiagnosisContent.all
  end
end
