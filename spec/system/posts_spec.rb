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
  end
end
