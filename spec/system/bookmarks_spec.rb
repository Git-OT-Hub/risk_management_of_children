require 'rails_helper'

RSpec.describe "Bookmarks", type: :system do
  let(:me) { create(:user) }
  let(:my_post) { create(:post, user: me) }
  let(:post_by_others) { create(:post) }
  let(:my_bookmark) { create(:bookmark, user: me, post: post_by_others) }

  describe "bookmarkのcreate,destroy機能" do
    before do
      my_post
      post_by_others
    end

    context "ログインしていない場合" do
      it "bookmarkアイコンが表示されないこと", js: true do
        visit posts_path
        expect(page).to have_content "投稿一覧"
        within("#post_#{post_by_others.id}") do
          expect(page).not_to have_selector "#bookmark_post_#{post_by_others.id}"
        end
        within("#post_#{my_post.id}") do
          expect(page).not_to have_selector "#bookmark_post_#{my_post.id}"
        end
      end
    end

    context "ログインしている場合" do
      before { login_as(me) }

      it "自分の投稿には、bookmarkアイコンが表示されず、他ユーザーの投稿には、bookmarkアイコンが表示されること", js: true do
        expect(page).to have_content "ログインしました"
        visit posts_path
        expect(page).to have_content "投稿一覧"
        within("#post_#{post_by_others.id}") do
          expect(page).to have_selector "#bookmark_post_#{post_by_others.id}"
        end
        within("#post_#{my_post.id}") do
          expect(page).not_to have_selector "#bookmark_post_#{my_post.id}"
        end
      end

      it "他ユーザーの投稿を、お気に入り登録できること", js: true do
        expect(page).to have_content "ログインしました"
        visit posts_path
        expect(page).to have_content "投稿一覧"
        within("#bookmark_post_#{post_by_others.id}") do
          click_link "button-bookmark-#{post_by_others.id}"
        end
        expect(page).to have_content "お気に入り登録しました"
        within("#bookmark_post_#{post_by_others.id}") do
          expect(page).not_to have_selector "#button-bookmark-#{post_by_others.id}"
          expect(page).to have_selector "#button-unbookmark-#{post_by_others.id}"
        end
      end

      it "他ユーザーの投稿を、お気に入り登録解除できること", js: true do
        expect(page).to have_content "ログインしました"
        my_bookmark
        visit posts_path
        expect(page).to have_content "投稿一覧"
        within("#bookmark_post_#{post_by_others.id}") do
          click_link "button-unbookmark-#{post_by_others.id}"
        end
        expect(page.accept_confirm).to eq "お気に入り登録を解除しますか？"
        expect(page).to have_content "お気に入り登録を解除しました"
        within("#bookmark_post_#{post_by_others.id}") do
          expect(page).not_to have_selector "#button-unbookmark-#{post_by_others.id}"
          expect(page).to have_selector "#button-bookmark-#{post_by_others.id}"
        end
      end
    end
  end
end
