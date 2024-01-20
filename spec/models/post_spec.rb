require 'rails_helper'

RSpec.describe Post, type: :model do
  describe "validation" do
    context "全てのフィールドが有効な場合" do
      it "有効であること" do
        post = build(:post)
        expect(post).to be_valid
      end
    end

    context "タイトルが存在しない場合" do
      it "無効であること" do
        post = build(:post, title: nil)
        expect(post).to be_invalid
        expect(post.errors[:title]).to include("を入力してください")
      end
    end

    context "タイトルが255文字以下の場合" do
      it "有効であること" do
        post = build(:post, title: "a" * 255)
        expect(post).to be_valid
      end
    end

    context "タイトルが256文字以上の場合" do
      it "無効であること" do
        post = build(:post, title: "a" * 256)
        expect(post).to be_invalid
        expect(post.errors[:title]).to include("は255文字以内で入力してください")
      end
    end

    context "本文が65535文字以下の場合" do
      it "有効であること" do
        post = build(:post, body: "a" * 65535)
        expect(post).to be_valid
      end
    end

    context "本文が65536文字以上の場合" do
      it "無効であること" do
        post = build(:post, body: "a" * 65536)
        expect(post).to be_invalid
        expect(post.errors[:body]).to include("は65535文字以内で入力してください")
      end
    end

    context "投稿画像が JPEG, JPG, PNG, GIF 以外の場合" do
      it "無効であること" do
        post = build(:post)
        post.images.attach(io: File.open("spec/fixtures/test.pdf"), filename: "test.pdf", content_type: "application/pdf")
        expect(post).to be_invalid
        expect(post.errors[:images]).to include(": ファイル形式が、JPEG, JPG, PNG, GIF 以外になっています。ファイル形式をご確認ください。")
      end
    end

    context "投稿画像が 5MB を超える場合" do
      it "無効であること" do
        post = build(:post)
        post.images.attach(io: File.open("spec/fixtures/10MB.png"), filename: "10MB.png", content_type: "image/png")
        expect(post).to be_invalid
        expect(post.errors[:images]).to include(": 1枚あたり、5MB以下にしてください。")
      end
    end

    context "投稿画像が 4枚以下 の場合" do
      it "有効であること" do
        post = build(:post)
        images = Array.new(4) do
          {
            io: File.open("spec/fixtures/test1.png"),
            filename: "test1.png",
            content_type: "image/png"
          }
        end
        post.images.attach(images)
        expect(post).to be_valid
      end
    end

    context "投稿画像が 5枚以上 の場合" do
      it "無効であること" do
        post = build(:post)
        images = Array.new(5) do
          {
            io: File.open("spec/fixtures/test1.png"),
            filename: "test1.png",
            content_type: "image/png"
          }
        end
        post.images.attach(images)
        expect(post).to be_invalid
        expect(post.errors[:images]).to include(": 4枚以下にしてください。")
      end
    end
  end
end
