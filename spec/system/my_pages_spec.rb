require 'rails_helper'

RSpec.describe "MyPages", type: :system do
  let(:me) { create(:user) }
  let(:others) { create(:user) }
  let(:me_with_avatar) { create(:user, :with_avatar) }

  describe "マイページのCRUD" do

    describe "詳細機能" do
      context "ログインしていない場合" do
        it "マイページに遷移できないこと" do
          visit my_page_path
          expect(page).to have_content "ログインしてください"
        end
      end

      context "ログインしている場合" do
        before { login_as(me) }

        it "マイページに遷移でき、他ユーザーの情報が表示されていないこと" do
          expect(page).to have_content "ログインしました"
          visit my_page_path
          expect(page).to have_content "マイページ"
          expect(page).to have_content me.name
          expect(page).to have_content me.email
          expect(page).not_to have_content others.name
          expect(page).not_to have_content others.email
        end
      end
    end

    describe "編集機能" do
      context "ログインしていない場合" do
        it "編集できないこと" do
          visit edit_my_page_path
          expect(page).to have_content "ログインしてください"
        end
      end

      context "ログインしている場合" do
        before { login_as(me) }

        context "フォームの入力値が正常な場合" do
          it "編集できること" do
            expect(page).to have_content "ログインしました"
            visit edit_my_page_path
            expect(page).to have_content "ユーザー登録情報の編集"
            fill_in "名前", with: "change_name"
            fill_in "メールアドレス", with: "change_email@example.com"
            file_path = Rails.root.join("spec", "fixtures", "test1.png")
            attach_file "アバター", file_path
            click_on "更新する"
            expect(page).to have_content "ユーザーを更新しました"
            expect(page).to have_selector "img[src$='test1.png']"
            expect(page).to have_content "change_name"
            expect(page).to have_content "change_email@example.com"
          end
        end

        context "名前が未入力の場合" do
          it "編集できないこと" do
            expect(page).to have_content "ログインしました"
            visit edit_my_page_path
            expect(page).to have_content "ユーザー登録情報の編集"
            fill_in "名前", with: ""
            fill_in "メールアドレス", with: "change_email@example.com"
            click_on "更新する"
            expect(page).to have_content "ユーザーを更新できませんでした"
            expect(page).to have_content "名前を入力してください"
            expect(current_path).to eq edit_my_page_path
          end
        end

        context "メールアドレスが未入力の場合" do
          it "編集できないこと" do
            expect(page).to have_content "ログインしました"
            visit edit_my_page_path
            expect(page).to have_content "ユーザー登録情報の編集"
            fill_in "名前", with: "change_name"
            fill_in "メールアドレス", with: ""
            click_on "更新する"
            expect(page).to have_content "ユーザーを更新できませんでした"
            expect(page).to have_content "メールアドレスを入力してください"
            expect(current_path).to eq edit_my_page_path
          end
        end

        context "登録済のメールアドレスを使用した場合" do
          before { others }

          it "編集できないこと" do
            expect(page).to have_content "ログインしました"
            visit edit_my_page_path
            expect(page).to have_content "ユーザー登録情報の編集"
            fill_in "名前", with: "change_name"
            fill_in "メールアドレス", with: others.email
            click_on "更新する"
            expect(page).to have_content "ユーザーを更新できませんでした"
            expect(page).to have_content "メールアドレスはすでに存在します"
            expect(current_path).to eq edit_my_page_path
          end
        end

        context "フォーム送信前に添付画像の削除ボタンを押した場合" do
          it "アバターの登録がなく、新規に画像を添付した後、削除ボタンを押しても削除ができること", js: true do
            expect(page).to have_content "ログインしました"
            visit edit_my_page_path
            expect(page).to have_content "ユーザー登録情報の編集"
            fill_in "名前", with: "change_name"
            fill_in "メールアドレス", with: "change_email@example.com"
            file_path = Rails.root.join("spec", "fixtures", "test1.png")
            attach_file "アバター", file_path
            click_on "削除"
            click_on "更新する"
            expect(page).to have_content "ユーザーを更新しました"
            expect(current_path).to eq my_page_path
            expect(page).not_to have_selector "img[src$='test1.png']"
            expect(page).to have_content "change_name"
            expect(page).to have_content "change_email@example.com"
          end
        end
      end

      context "ログインしている場合" do
        before { login_as(me_with_avatar) }

        context "フォーム送信前に添付画像の削除ボタンを押した場合" do
          it "既に登録済みのアバターを削除ボタンで削除できること", js: true do
            expect(page).to have_content "ログインしました"
            visit edit_my_page_path
            expect(page).to have_content "ユーザー登録情報の編集"
            fill_in "名前", with: "change_name"
            fill_in "メールアドレス", with: "change_email@example.com"
            click_on "削除"
            click_on "更新する"
            expect(page).to have_content "ユーザーを更新しました"
            expect(current_path).to eq my_page_path
            expect(page).not_to have_selector "img[src$='test1.png']"
            expect(page).to have_content "change_name"
            expect(page).to have_content "change_email@example.com"
          end
        end
      end
    end
  end
end
