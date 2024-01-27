require 'rails_helper'

RSpec.describe "Favorites", type: :system do
  let(:me) { create(:user) }
  let(:my_post) { create(:post, user: me) }
  let(:post_by_others) { create(:post) }
  let(:my_favorite) { create(:favorite, user: me, post: post_by_others) }

  describe "favoriteのcreate,destroy機能" do
    before do
      my_post
      post_by_others
    end

    context "ログインしていない場合" do
      it "favoriteアイコンが表示されないこと", js: true do
        visit posts_path
        expect(page).to have_content "投稿一覧"
        within("#post_#{post_by_others.id}") do
          expect(page).not_to have_selector "#favorite_post_#{post_by_others.id}"
        end
        within("#post_#{my_post.id}") do
          expect(page).not_to have_selector "#favorite_post_#{my_post.id}"
        end
      end
    end

    context "ログインしている場合" do
      before { login_as(me) }

      it "自分の投稿には、favoriteアイコンが表示されず、他ユーザーの投稿には、favoriteアイコンが表示されること", js: true do
        expect(page).to have_content "ログインしました"
        visit posts_path
        expect(page).to have_content "投稿一覧"
        within("#post_#{post_by_others.id}") do
          expect(page).to have_selector "#favorite_post_#{post_by_others.id}"
        end
        within("#post_#{my_post.id}") do
          expect(page).not_to have_selector "#favorite_post_#{my_post.id}"
        end
      end

      it "他ユーザーの投稿を、いいねできること", js: true do
        expect(page).to have_content "ログインしました"
        visit posts_path
        expect(page).to have_content "投稿一覧"
        within("#favorite_post_#{post_by_others.id}") do
          click_link "button-favorite-#{post_by_others.id}"
        end
        expect(page).to have_content "いいねしました"
        within("#favorite_post_#{post_by_others.id}") do
          expect(page).not_to have_selector "#button-favorite-#{post_by_others.id}"
          expect(page).to have_selector "#button-remove-favorite-#{post_by_others.id}"
        end
      end

      it "他ユーザーの投稿において、いいねの解除ができること", js: true do
        expect(page).to have_content "ログインしました"
        my_favorite
        visit posts_path
        expect(page).to have_content "投稿一覧"
        within("#favorite_post_#{post_by_others.id}") do
          click_link "button-remove-favorite-#{post_by_others.id}"
        end
        expect(page).to have_content "いいねを解除しました"
        within("#favorite_post_#{post_by_others.id}") do
          expect(page).not_to have_selector "#button-remove-favorite-#{post_by_others.id}"
          expect(page).to have_selector "#button-favorite-#{post_by_others.id}"
        end
      end
    end
  end
end
