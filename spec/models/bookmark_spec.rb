require 'rails_helper'

RSpec.describe Bookmark, type: :model do
  context "user_id と post_id の組み合わせが重複しない時" do
    it "有効であること" do
      user = create(:user)
      post = create(:post)
      another_post = create(:post)

      bookmark = create(:bookmark, user: user, post: post)
      another_bookmark = build(:bookmark, user: user, post: another_post)
      expect(another_bookmark).to be_valid
    end
  end

  context "user_id と post_id の組み合わせが重複する時" do
    it "無効であること" do
      user = create(:user)
      post = create(:post)

      bookmark = create(:bookmark, user: user, post: post)
      same_bookmark = build(:bookmark, user: user, post: post)
      expect(same_bookmark).to be_invalid
    end
  end
end
