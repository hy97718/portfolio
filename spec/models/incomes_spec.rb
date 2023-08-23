require 'rails_helper'

RSpec.describe Income, type: :model do
  let(:user) { create(:user) }
  let(:location) { create(:location, user: user) }

  describe "validation" do
    it "正しい属性値で有効であること" do
      income = Income.new(
        income_name: "テスト収入",
        income_day: Date.today,
        income_money: 1000,
        income_memo: "テストメモ",
        user: user,
        location: location
      )
      expect(income).to be_valid
    end

    it "income_nameがない場合は無効であること" do
      income = Income.new(income_name: nil)
      income.valid?
      expect(income.errors[:income_name]).to include("を入力してください")
    end

    it "income_nameが長すぎる場合は無効であること" do
      income = Income.new(income_name: "a" * 21)
      income.valid?
      expect(income.errors[:income_name]).to include("は20文字以内で入力してください")
    end

    it "income_dayがない場合は無効であること" do
      income = Income.new(income_day: nil)
      income.valid?
      expect(income.errors[:income_day]).to include("を入力してください")
    end

    it "income_moneyがない場合は無効であること" do
      income = Income.new(income_money: nil)
      income.valid?
      expect(income.errors[:income_money]).to include("を入力してください")
    end

    it "income_moneyが負の値の場合は無効であること" do
      income = Income.new(income_money: -1000)
      income.valid?
      expect(income.errors[:income_money]).to include("は0以上の値にしてください")
    end

    it "income_moneyが整数でない場合は無効であること" do
      income = Income.new(income_money: 1000.5)
      income.valid?
      expect(income.errors[:income_money]).to include("は整数で入力してください")
    end

    it "income_memoがnilであっても有効であること" do
      income = Income.new(
        income_name: "テスト収入",
        income_day: Date.today,
        income_money: 1000,
        income_memo: nil,
        user: user,
        location: location
      )
      expect(income).to be_valid
    end

    it "income_memoが長すぎる場合は無効であること" do
      income = Income.new(income_memo: "a" * 51)
      income.valid?
      expect(income.errors[:income_memo]).to include("は50文字以内で入力してください")
    end
  end

  describe ".search" do
    it "income_nameに一致する収入を返すこと" do
      income1 = create(:income, income_name: "テスト収入1", user: user, location: location)
      income2 = create(:income, income_name: "テスト収入2", user: user, location: location)
      income3 = create(:income, income_name: "別の収入", user: user, location: location)

      results = Income.search("テスト")
      expect(results).to contain_exactly(income1, income2)
      expect(results).not_to contain_exactly(income3)
    end

    it "income_memoに一致する収入を返すこと" do
      income1 = create(:income, income_memo: "テストメモ1", user: user, location: location)
      income2 = create(:income, income_memo: "テストメモ2", user: user, location: location)
      income3 = create(:income, income_memo: "別のメモ", user: user, location: location)

      results = Income.search("テスト")
      expect(results).to contain_exactly(income1, income2)
      expect(results).not_to contain_exactly(income3)
    end
  end
end
