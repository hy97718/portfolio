require 'rails_helper'

RSpec.describe "Dashboards", js: true, type: :system do
  let(:user) { create(:user) }
  let(:location) { create(:location, user: user) }
  let!(:incomes) { Array.new(3) { create(:income, user: user, location: location) } }
  let!(:expenses) { Array.new(2) { create(:expense, user: user, location: location) } }

  before do
    sign_in user
    visit user_dashboards_path(user)
  end

  describe "index page" do
    it "総収入、総支出、総資産が表示されること" do
      expect(page).to have_content("総収入: #{user.incomes.sum(:income_money)}")
      expect(page).to have_content("総支出: #{user.expenses.sum(:expense_money)}")
      expect(page).to have_content("総資産: #{user.incomes.sum(:income_money) - user.expenses.sum(:expense_money)}")
    end

    it "目標達成のメッセージが表示されること" do
      user.update(savings_target: 1000)
      visit user_dashboards_path(user)
      expect(page).to have_content("おめでとうございます！目標貯金額を達成しました！")
      expect(page).to have_selector(".message-image")
    end
  end
end
