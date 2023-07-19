require 'rails_helper'

RSpec.describe Expense, type: :model do
  let(:user) { create(:user) }
  let(:location) { create(:location, user: user) }

  describe "バリデーション" do
    it "正しい属性値で有効であること" do
      expense = Expense.new(
        expense_name: "テスト出費",
        expense_day: Date.today,
        expense_money: 1000,
        expense_memo: "テストメモ",
        user: user,
        location: location
      )
      expect(expense).to be_valid
    end

    it "expense_nameがない場合は無効であること" do
      expense = Expense.new(expense_name: nil)
      expense.valid?
      expect(expense.errors[:expense_name]).to include("を入力してください")
    end

    it "expense_nameが長すぎる場合は無効であること" do
      expense = Expense.new(expense_name: "a" * 21)
      expense.valid?
      expect(expense.errors[:expense_name]).to include("は20文字以内で入力してください")
    end

    it "expense_dayがない場合は無効であること" do
      expense = Expense.new(expense_day: nil)
      expense.valid?
      expect(expense.errors[:expense_day]).to include("を入力してください")
    end

    it "expense_moneyがない場合は無効であること" do
      expense = Expense.new(expense_money: nil)
      expense.valid?
      expect(expense.errors[:expense_money]).to include("を入力してください")
    end

    it "expense_moneyが負の値の場合は無効であること" do
      expense = Expense.new(expense_money: -1000)
      expense.valid?
      expect(expense.errors[:expense_money]).to include("は0以上の値にしてください")
    end

    it "expense_moneyが整数でない場合は無効であること" do
      expense = Expense.new(expense_money: 1000.5)
      expense.valid?
      expect(expense.errors[:expense_money]).to include("は整数で入力してください")
    end

    it "expense_memoがnilであっても有効であること" do
      expense = Expense.new(
        expense_name: "テスト収入",
        expense_day: Date.today,
        expense_money: 1000,
        expense_memo: nil,
        user: user,
        location: location
      )
      expect(expense).to be_valid
    end

    it "expense_memoが長すぎる場合は無効であること" do
      expense = Expense.new(expense_memo: "a" * 51)
      expense.valid?
      expect(expense.errors[:expense_memo]).to include("は50文字以内で入力してください")
    end
  end

  describe ".search" do
    it "expense_nameに一致する出費を返すこと" do
      expense1 = create(:expense, expense_name: "テスト出費1", user: user, location: location)
      expense2 = create(:expense, expense_name: "テスト出費2", user: user, location: location)
      expense3 = create(:expense, expense_name: "別の出費", user: user, location: location)

      results = Expense.search("テスト")
      expect(results).to contain_exactly(expense1, expense2)
      expect(results).not_to contain_exactly(expense3)
    end

    it "expense_memoに一致する出費を返すこと" do
      expense1 = create(:expense, expense_memo: "テストメモ1", user: user, location: location)
      expense2 = create(:expense, expense_memo: "テストメモ2", user: user, location: location)
      expense3 = create(:expense, expense_memo: "別のメモ", user: user, location: location)

      results = Expense.search("テスト")
      expect(results).to contain_exactly(expense1, expense2)
      expect(results).not_to contain_exactly(expense3)
    end
  end
end
