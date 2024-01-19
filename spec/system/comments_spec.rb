require 'rails_helper'

RSpec.describe "Comments", type: :system do
  let(:me) { create(:user) }
  let(:post) { create(:post) }
  let(:comment_by_me) { create(:comment, user: me, post: post) }
  let(:comment_by_others) { create(:comment, post: post) }

  describe "コメントのCRUD" do
    before do
      comment_by_me
      comment_by_others
    end

    describe "コメントの一覧" do
      it "コメントの一覧が表示されること" do
        visit post_path post
        expect(page).to have_content "投稿詳細"
        within("#comments_post_#{post.id}") do
          expect(page).to have_content comment_by_me.body
          expect(page).to have_content comment_by_me.user.name
          expect(page).to have_content comment_by_others.body
          expect(page).to have_content comment_by_others.user.name
        end
      end
    end

    describe "ログインしていない場合" do
      it "コメント作成ができないこと" do
        visit post_path post
        expect(page).to have_content "投稿詳細"
        click_on "コメントする"
        expect(page).to have_content "ログインしてください"
        expect(current_path).to eq login_path
      end
    end

    describe "コメントの作成" do
      before { login_as(me) }

      it "コメントを作成できること", js: true do
        expect(page).to have_content "ログインしました"
        visit post_path post
        expect(page).to have_content "投稿詳細"
        click_on "コメントする"
        expect(page).to have_selector "form"
        fill_in "コメント", with: "新規コメント"
        file_path = Rails.root.join("spec", "fixtures", "test1.png")
        attach_file "画像", file_path
        click_on "投稿する"
        expect(page).to have_content "コメントを作成しました"
        comment = Comment.last
        within("#comment_#{comment.id}") do
          expect(page).to have_content me.name
          expect(page).to have_content "新規コメント"
          expect(page).to have_selector "img[src$='test1.png']"
        end
      end

      it "コメントの作成に失敗すること", js: true do
        expect(page).to have_content "ログインしました"
        visit post_path post
        expect(page).to have_content "投稿詳細"
        click_on "コメントする"
        expect(page).to have_selector "form"
        fill_in "コメント", with: ""
        file_path = Rails.root.join("spec", "fixtures", "test1.png")
        attach_file "画像", file_path
        click_on "投稿する"
        expect(page).to have_content "コメントを作成できませんでした"
        expect(page).to have_content "コメントを入力してください"
      end

      it "コメント作成をキャンセルできること", js: true do
        expect(page).to have_content "ログインしました"
        visit post_path post
        expect(page).to have_content "投稿詳細"
        click_on "コメントする"
        expect(page).to have_selector "form"
        fill_in "コメント", with: "新規コメント"
        file_path = Rails.root.join("spec", "fixtures", "test1.png")
        attach_file "画像", file_path
        click_on "キャンセル"
        expect(page).not_to have_selector "form"
        within("#new_comment") do
          expect(page).to have_content "コメントする"
        end
      end

      it "コメントフォーム送信前に添付画像が削除できること", js: true do
        expect(page).to have_content "ログインしました"
        visit post_path post
        expect(page).to have_content "投稿詳細"
        within("#new_comment") do
          click_on "コメントする"
          expect(page).to have_selector "form"
          fill_in "コメント", with: "新規コメント"
          file_path = Rails.root.join("spec", "fixtures", "test1.png")
          attach_file "画像", file_path
          click_on "削除"
          click_on "投稿する"
        end
        expect(page).to have_content "コメントを作成しました"
        comment = Comment.last
        within("#comment_#{comment.id}") do
          expect(page).to have_content me.name
          expect(page).to have_content "新規コメント"
          expect(page).not_to have_selector "img[src$='test1.png']"
        end
      end
    end

    describe "コメントの編集" do
      before { login_as(me) }

      it "他人のコメントの場合、編集ボタン・削除ボタンが表示されないこと", js: true do
        expect(page).to have_content "ログインしました"
        visit post_path post
        expect(page).to have_content "投稿詳細"
        within("#comment_#{comment_by_others.id}") do
          expect(page).not_to have_selector "#button-edit-#{comment_by_others.id}"
          expect(page).not_to have_selector "#button-delete-#{comment_by_others.id}"
        end
      end

      it "コメント及び画像の変更ができること", js: true do
        expect(page).to have_content "ログインしました"
        visit post_path post
        expect(page).to have_content "投稿詳細"
        click_on "コメントする"
        expect(page).to have_selector "form"
        fill_in "コメント", with: "新規コメント"
        file_path = Rails.root.join("spec", "fixtures", "test1.png")
        attach_file "画像", file_path
        click_on "投稿する"
        expect(page).to have_content "コメントを作成しました"
        comment = Comment.last
        within("#comment_#{comment.id}") do
          click_link "button-edit-#{comment.id}"
          expect(page).to have_selector "form"
          fill_in "コメント", with: "編集コメント"
          click_on "削除"
          file_path = Rails.root.join("spec", "fixtures", "test2.png")
          attach_file "画像", file_path
          click_on "更新する"
          expect(page).to have_content me.name
          expect(page).not_to have_content "新規コメント"
          expect(page).to have_content "編集コメント"
          expect(page).not_to have_selector "img[src$='test1.png']"
          expect(page).to have_selector "img[src$='test2.png']"
        end
      end
    end

    describe "コメントの削除" do
      before { login_as(me) }

      it "コメントの削除ができること", js: true do
        expect(page).to have_content "ログインしました"
        visit post_path post
        expect(page).to have_content "投稿詳細"
        click_on "コメントする"
        expect(page).to have_selector "form"
        fill_in "コメント", with: "新規コメント"
        file_path = Rails.root.join("spec", "fixtures", "test1.png")
        attach_file "画像", file_path
        click_on "投稿する"
        expect(page).to have_content "コメントを作成しました"
        comment = Comment.last
        within("#comment_#{comment.id}") do
          click_link "button-delete-#{comment.id}"
        end
        expect(page.accept_confirm).to eq "削除しますか？"
        expect(page).to have_content "コメントを削除しました"
        expect(page).not_to have_selector "#comment_#{comment.id}"
      end
    end
  end
end
