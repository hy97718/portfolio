require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  describe "validations"  do
    it "ユーザー名と目標貯金額とemailとpasswordのバリデーションが有効であること" do
      user = User.new(
        username:     "test",
        email:    "test@test.com",
        password: "sample1234"
      )
      expect(user).to be_valid
    end

    it "emailが重複している場合は無効であること" do
      User.create(
        username:     "abc",
        email:    "hoge@hoge.com",
        password: "sample1234"
      )
      user = User.new(
        username:     "ABCD",
        email:    "hoge@hoge.com",
        password: "sample1234"
      )
      user.valid?
      expect(user.errors[:email]).to include("はすでに存在します")
    end
    it "passwordが英数を含む6文字以上でなければ無効であること" do
      user = User.new(
        username:     "test1",
        email:    "test1@test.com",
        password: "t12"
      )
      user.valid?
      expect(user.errors[:password]).to include("は6文字以上で入力してください")
    end
  end

  describe "methods" do
    it "ゲストユーザーの場合、trueを返すこと" do
      guest_user = create(:user, email: "guest@example.com")
      expect(guest_user.guest?).to be_truthy
    end

    it "ゲストユーザーでない場合、falseを返すこと" do
      expect(user.guest?).to be_falsy
    end
  end

  describe "class methods" do
    it "グストユーザーが作成されること" do
      guest_user = User.guest
      expect(guest_user).to be_a(User)
      expect(guest_user.email).to eq("guest@example.com")
    end
  end
end
