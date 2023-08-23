require 'rails_helper'

RSpec.describe "Searches", type: :system do
  let(:user) { create(:user) }
  let(:location) { create(:location, user: user) }
  let(:keyword_income) { "Income_with_keyword" }
  let(:keyword_expense) { "Expense_with_keyword" }
  let!(:income) { create(:income, user: user, location: location, income_name: "Income_with_keyword") }
  let!(:expense) { create(:expense, user: user, location: location, expense_name: "Expense_with_keyword") }

  before do
    sign_in user
  end

  describe "index page" do
    before do
      visit user_searches_path(user)
    end

    it "検索フォームが表示されること" do
      expect(page).to have_selector("form[action='#{user_searches_path(user)}'][method='get']")
      expect(page).to have_field("keyword", type: "text")
      expect(page).to have_button("検索")
    end

    it "検索結果が表示されないこと" do
      expect(page).to have_content("検索結果がありません")
    end

    context "検索キーワードが入力された場合" do
      before do
        fill_in "keyword", with: "Income"
        click_button "検索"
      end

      it "検索結果が表示されること" do
        expect(page).to have_content("検索結果")
        expect(page).to have_link(income.income_name, href: location_income_path(location, income))
        expect(page).not_to have_content("検索結果がありません")
      end

      it "誤った検索結果が表示されないこと" do
        expect(page).not_to have_content(expense.expense_name)
      end
    end
  end
end
