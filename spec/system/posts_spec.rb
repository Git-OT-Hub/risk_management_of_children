require 'rails_helper'

RSpec.describe "Posts", type: :system do
  let(:user) { create(:user) }
  let(:post) { create(:post, user: user) }

  describe "投稿のCRUD" do
    describe "投稿の一覧" do
      context "投稿が一件もない場合" do
        it "何も無い旨のメッセージが表示される" do
          visit posts_path
          expect(page).to have_content "投稿がありません"
        end
      end

      context "投稿がある場合" do
        it "投稿一覧が表示される" do
          post
          visit posts_path
          expect(page).to have_content post.title
          expect(page).to have_content post.user.name
        end
      end
    end

    describe "投稿の作成" do
      context "ログインしていない場合" do
        it "ログイン画面にリダイレクトされる" do
          visit new_post_path
          expect(current_path).to eq login_path
          expect(page).to have_content "ログインしてください"
        end
      end

      context "ログインしている場合" do
        before { login_as(user) }

        it "投稿が作成できる" do
          expect(page).to have_content "ログインしました"
          visit new_post_path
          expect(page).to have_content "投稿作成"
          fill_in "タイトル", with: "testタイトル"
          fill_in "本文", with: "test本文"
          click_button "投稿"
          expect(page).to have_content "投稿を作成しました"
          expect(page).to have_content "testタイトル"
        end

        it "投稿の作成に失敗する" do
          expect(page).to have_content "ログインしました"
          visit new_post_path
          expect(page).to have_content "投稿作成"
          fill_in "タイトル", with: ""
          fill_in "本文", with: "test本文"
          click_button "投稿"
          expect(page).to have_content "投稿を作成できませんでした"
          expect(current_path).to eq new_post_path
        end
      end
    end
  end
end
