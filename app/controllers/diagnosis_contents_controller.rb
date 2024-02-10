class DiagnosisContentsController < ApplicationController
  skip_before_action :require_login, only: %i[index new create show edit update destroy]

  def index; end
  def new; end
  def create; end
  def show; end
  def edit; end
  def update; end
  def destroy; end

end
