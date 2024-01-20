require 'rails_helper'

RSpec.describe Comment, type: :model do

  context "全てのフィールドが有効な場合" do
    it "有効であること" do
      comment = build(:comment, :with_comment_image)
      expect(comment).to be_valid
    end
  end

  context "本文が存在しない場合" do
    it "無効であること" do
      comment = build(:comment, :with_comment_image, body: nil)
      expect(comment).to be_invalid
      expect(comment.errors[:body]).to include("を入力してください")
    end
  end

  context "本文が65535文字以下の場合" do
    it "有効であること" do
      comment = build(:comment, :with_comment_image, body: "a" * 65535)
      expect(comment).to be_valid
    end
  end

  context "本文が65536文字以上の場合" do
    it "無効であること" do
      comment = build(:comment, :with_comment_image, body: "a" * 65536)
      expect(comment).to be_invalid
      expect(comment.errors[:body]).to include("は65535文字以内で入力してください")
    end
  end

  context "投稿画像が JPEG, JPG, PNG, GIF 以外の場合" do
    it "無効であること" do
      comment = build(:comment)
      comment.comment_image.attach(io: File.open("spec/fixtures/test.pdf"), filename: "test.pdf", content_type: "application/pdf")
      expect(comment).to be_invalid
      expect(comment.errors[:comment_image]).to include(": ファイル形式が、JPEG, JPG, PNG, GIF 以外になっています。ファイル形式をご確認ください。")
    end
  end

  context "投稿画像が 5MB を超える場合" do
    it "無効であること" do
      comment = build(:comment)
      comment.comment_image.attach(io: File.open("spec/fixtures/10MB.png"), filename: "10MB.png", content_type: "image/png")
      expect(comment).to be_invalid
      expect(comment.errors[:comment_image]).to include(": 1枚あたり、5MB以下にしてください。")
    end
  end
end
