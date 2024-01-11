require 'rails_helper'

RSpec.describe "Posts", type: :system do
  let(:user) { create(:user) }
  let(:post) { create(:post, user: user) }
  let(:post_by_others) { create(:post) }
  let(:post_with_image) { create(:post, :with_image, user: user) }

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
          file_path = Rails.root.join("spec", "fixtures", "test1.png")
          attach_file "画像", file_path
          click_button "投稿"
          expect(page).to have_content "投稿を作成しました"
          expect(page).to have_content "testタイトル"
          expect(page).to have_selector "img[src$='test1.png']"
        end

        it "タイトルが未入力の場合、投稿の作成に失敗する" do
          expect(page).to have_content "ログインしました"
          visit new_post_path
          expect(page).to have_content "投稿作成"
          fill_in "タイトル", with: ""
          fill_in "本文", with: "test本文"
          click_button "投稿"
          expect(page).to have_content "投稿を作成できませんでした"
          expect(page).to have_content "タイトルを入力してください"
          expect(current_path).to eq new_post_path
        end
      end
    end

    describe "投稿の編集・削除" do
      before { login_as(user) }

      context "他人の掲示板の場合" do
        it "編集ボタン・削除ボタンが表示されないこと" do
          expect(page).to have_content "ログインしました"
          visit post_path post_by_others
          expect(page).to have_content "投稿詳細"
          expect(page).not_to have_selector("#button-edit-#{post_by_others.id}")
          expect(page).not_to have_selector("#button-delete-#{post_by_others.id}")
        end
      end

      context "自分の掲示板の場合" do
        it "編集ボタン・削除ボタンが表示されること" do
          expect(page).to have_content "ログインしました"
          visit post_path post
          expect(page).to have_content "投稿詳細"
          expect(page).to have_selector("#button-edit-#{post.id}")
          expect(page).to have_selector("#button-delete-#{post.id}")
        end

        it "タイトル・本文が編集でき、画像が追加できること" do
          expect(page).to have_content "ログインしました"
          visit post_path post
          expect(page).to have_content "投稿詳細"
          click_link "button-edit-#{post.id}"
          expect(page).to have_content "投稿編集"
          fill_in "タイトル", with: "タイトル編集"
          fill_in "本文", with: "本文編集"
          file_path = Rails.root.join("spec", "fixtures", "test1.png")
          attach_file "画像", file_path
          click_button "更新する"
          expect(page).to have_content "投稿を更新しました"
          expect(page).to have_content "タイトル編集"
          expect(page).to have_content "本文編集"
          expect(page).to have_selector "img[src$='test1.png']"
        end

        it "投稿済の画像が削除できること" do
          expect(page).to have_content "ログインしました"
          visit post_path post_with_image
          expect(page).to have_content "投稿詳細"
          click_link "button-edit-#{post_with_image.id}"
          expect(page).to have_content "投稿編集"
          fill_in "タイトル", with: "タイトル編集"
          fill_in "本文", with: "本文編集"
          post_with_image.images.each do |image|
            click_link "rspec-image-#{image.id}"
            expect(page).not_to have_selector "img[src$='test1.png']"
          end
          click_button "更新する"
          expect(page).to have_content "投稿を更新しました"
          expect(page).to have_content "タイトル編集"
          expect(page).to have_content "本文編集"
          expect(page).not_to have_selector "img[src$='test1.png']"
        end

        it "投稿の削除ができること" do
          expect(page).to have_content "ログインしました"
          visit post_path post
          expect(page).to have_content "投稿詳細"
          click_link "button-delete-#{post.id}"
          expect(page.accept_confirm).to eq "削除しますか？"
          expect(page).to have_content "投稿を削除しました"
          expect(page).not_to have_selector "#post_#{post.id}"
          expect(current_path).to eq posts_path
        end
      end
    end
  end
end
