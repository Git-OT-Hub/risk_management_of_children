require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validation" do
    it "ユーザー登録ができる" do
      user = build(:user)
      expect(user).to be_valid
      expect(user.errors).to be_empty
    end

    it "名前空欄は無効" do
      user_without_name = build(:user, name: "")
      expect(user_without_name).to be_invalid
      expect(user_without_name.errors[:name]).to eq ["を入力してください"]
    end

    it "メールアドレス空欄は無効" do
      user_without_email = build(:user, email: "")
      expect(user_without_email).to be_invalid
      expect(user_without_email.errors[:email]).to eq ["を入力してください"]
    end

    it "同一メールアドレスは無効" do
      user = create(:user)
      user_with_duplicated_email = build(:user, email: user.email)
      expect(user_with_duplicated_email).to be_invalid
      expect(user_with_duplicated_email.errors[:email]).to eq ["はすでに存在します"]
    end

    it "別メールアドレスは有効" do
      user = create(:user)
      user_with_another_email = build(:user, email: "another@example.com")
      expect(user_with_another_email).to be_valid
      expect(user_with_another_email.errors).to be_empty
    end

    it "パスワードが8文字未満だと登録できない" do
      user_insufficient_word_count = build(:user, password: "1234567")
      expect(user_insufficient_word_count).to be_invalid
      expect(user_insufficient_word_count.errors[:password]).to eq ["は8文字以上で入力してください"]
    end
  end
end
