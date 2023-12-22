require 'rails_helper'

RSpec.describe "Users", type: :system do
  let(:user) { create(:user) }

  describe "ログイン前" do
    describe "ユーザー新規登録" do
      context "フォームの入力値が正常" do
        it "ユーザーの新規作成が成功する" do
          visit new_user_path
          fill_in "名前", with: "user_test"
          fill_in "メールアドレス", with: "email@example.com"
          fill_in "パスワード", with: "P@ssw0rd"
          fill_in "パスワード確認", with: "P@ssw0rd"
          click_button "登録"
          expect(page).to have_content "ユーザー登録が完了しました"
        end
      end

      context "名前が未入力" do
        it "ユーザーの新規作成が失敗する" do
          visit new_user_path
          fill_in "名前", with: ""
          fill_in "メールアドレス", with: "email@example.com"
          fill_in "パスワード", with: "P@ssw0rd"
          fill_in "パスワード確認", with: "P@ssw0rd"
          click_button "登録"
          expect(page).to have_content "ユーザー登録に失敗しました"
          expect(page).to have_content "名前を入力してください"
          expect(current_path).to eq new_user_path
        end
      end

      context "メールアドレスが未入力" do
        it "ユーザーの新規作成が失敗する" do
          visit new_user_path
          fill_in "名前", with: "user_test"
          fill_in "メールアドレス", with: ""
          fill_in "パスワード", with: "P@ssw0rd"
          fill_in "パスワード確認", with: "P@ssw0rd"
          click_button "登録"
          expect(page).to have_content "ユーザー登録に失敗しました"
          expect(page).to have_content "メールアドレスを入力してください"
          expect(current_path).to eq new_user_path
        end
      end

      context "登録済のメールアドレスを使用" do
        it "ユーザーの新規作成が失敗する" do
          existed_user = create(:user)
          visit new_user_path
          fill_in "名前", with: "user_test"
          fill_in "メールアドレス", with: existed_user.email
          fill_in "パスワード", with: "P@ssw0rd"
          fill_in "パスワード確認", with: "P@ssw0rd"
          click_button "登録"
          expect(page).to have_content "ユーザー登録に失敗しました"
          expect(page).to have_content "メールアドレスはすでに存在します"
          expect(current_path).to eq new_user_path
          expect(page).to have_field "メールアドレス", with: existed_user.email
        end
      end

      context "パスワードが8文字未満" do
        it "ユーザーの新規作成が失敗する" do
          visit new_user_path
          fill_in "名前", with: "user_test"
          fill_in "メールアドレス", with: "email@example.com"
          fill_in "パスワード", with: "1234567"
          fill_in "パスワード確認", with: "1234567"
          click_button "登録"
          expect(page).to have_content "ユーザー登録に失敗しました"
          expect(page).to have_content "パスワードは8文字以上で入力してください"
          expect(current_path).to eq new_user_path
        end
      end
    end
  end

  describe "ログイン後" do
  end
end
