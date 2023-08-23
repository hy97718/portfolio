require 'rails_helper'

RSpec.describe Location, type: :model do
  let(:user) { create(:user) }
  let(:location) { create(:location, user: user) }
  let(:expense) { create(:expense, user: user, location: location) }
  let!(:incomes) { Array.new(3) { create(:income, location: location, user: user) } }
  let!(:expenses) { Array.new(2) { create(:expense, location: location, user: user) } }

  before do
    sign_in user
  end

  describe "validations" do
    it "asset_name,location_nameが存在する場合、有効であること" do
      location = Location.new(
        asset_name:     "テスト資産",
        location_name:    "現金",
        user_id: 1
      )
      expect(location).to be_valid
    end

    it "asset_name,location_nameが存在しない場合、無効であること" do
      location = Location.new(
        asset_name:     nil,
        location_name:     nil,
      )
      location.valid?
      expect(location.errors[:asset_name]).to include("を入力してください")
      expect(location.errors[:location_name]).to include("を入力してください")
    end
  end

  describe "methods" do
    it "残高を正しく返すこと" do
      expect(location.balance_money).to eq(incomes.sum(&:income_money) - expenses.sum(&:expense_money))
    end
  
    it "月間の支出合計を正しく返すこと" do
      month = expenses.first.expense_day.strftime("%Y-%m")
      expect(location.monthly_expense_total(month)).to eq(expenses.sum(&:expense_money))
    end
  end

  describe "#check_max_expense" do
    context "支出が上限金額を超える場合" do
      it "対応するメッセージを返すこと" do
        location.max_expense = 100
        expect(location.check_max_expense(expense)).to eq("上限金額を超えてしまいました。ここから挽回しましょう!")
      end
    end
  
    context "支出が上限金額の80%と等しい場合" do
      it "対応するメッセージを返すこと" do
        max_expense = 4000
        location.max_expense = max_expense * 0.8
        expect(location.check_max_expense(expense)).to eq("上限金額の8割になりました。気を引き締めましょう!")
      end
    end
  
    context "支出が上限金額の50%と等しい場合" do
      it "対応するメッセージを返すこと" do
        max_expense = 8000
        location.max_expense = max_expense * 0.5
        expect(location.check_max_expense(expense)).to eq("設定した上限金額の半分を超えました。使いすぎに気をつけましょう！！")
      end
    end
  
    context "支出が上限金額内の場合" do
      it "対応するメッセージを返すこと" do
        max_expense = 10000
        location.max_expense = max_expense
        expect(location.check_max_expense(expense)).to eq("#{location.location_name}の出金が登録されました。")
      end
    end
  end  
end
