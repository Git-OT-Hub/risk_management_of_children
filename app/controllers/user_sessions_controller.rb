class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create guest_login]
  before_action :check_not_logged_in, only: %i[new create guest_login]

  def new; end

  def create
    @user = login(params[:email], params[:password])

    if @user
      redirect_back_or_to root_path, success: t(".success")
    else
      flash.now[:danger] = t(".fail")
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to root_path, success: t(".success"), status: :see_other
  end

  def guest_login
    if current_user
      redirect_to root_path, danger: t("defaults.message.already_logged_in")
    end

    loop do
      random_email = SecureRandom.alphanumeric(10)
      unless User.exists?(email: "#{random_email}@example.com")
        @guest_email = "#{random_email}@example.com"
        break
      end
    end

    if @guest_user = User.create(name: "ゲスト", email: @guest_email, password: "password", password_confirmation: "password")
      auto_login(@guest_user)
      redirect_back_or_to root_path, success: t(".guest_login_success")
    else
      flash.now[:danger] = t(".guest_login_fail")
      render :new, status: :unprocessable_entity
    end
  end

  private

  def check_not_logged_in
    redirect_to root_path, danger: t("defaults.message.already_logged_in") if current_user
  end
end
