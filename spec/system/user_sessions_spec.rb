require 'rails_helper'

RSpec.describe "UserSessions", type: :system do
  let(:user) { create(:user) }

  describe "ログイン前" do
    context "フォームの入力値が正常" do
      it "ログイン処理が成功する" do
        visit login_path
        fill_in "メールアドレス", with: user.email
        fill_in "パスワード", with: "P@ssw0rd"
        click_button "ログイン"
        expect(page).to have_content "ログインしました"
      end
    end

    context "フォームが未入力" do
      it "ログイン処理が失敗する" do
        visit login_path
        fill_in "メールアドレス", with: ""
        fill_in "パスワード", with: "P@ssw0rd"
        click_button "ログイン"
        expect(page).to have_content "ログインに失敗しました"
        expect(current_path).to eq login_path
      end
    end

    context "「ゲストユーザーとしてログイン」をクリック" do
      it "ゲストユーザーとしてログインできる" do
        visit login_path
        click_link "ゲストユーザーとしてログイン"
        expect(page).to have_content "ゲストユーザーとしてログインしました"
      end
    end
  end

  describe "ログイン後" do
    before { login_as(user) }

    context "ログアウトボタンをクリック" do
      it "ログアウト処理が成功する" do
        click_link "ログアウト"
        expect(page.accept_confirm).to eq "ログアウトしますか？"
        expect(page).to have_content "ログアウトしました"
        expect(current_path).to eq root_path
      end
    end
  end
end
