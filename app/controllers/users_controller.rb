class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]
  before_action :check_not_logged_in, only: %i[new create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      auto_login(@user)
      redirect_back_or_to root_path, success: t(".success")
    else
      flash.now[:danger] = t(".fail")
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def check_not_logged_in
    redirect_to root_path, danger: t("defaults.message.already_logged_in") if current_user
  end
end
