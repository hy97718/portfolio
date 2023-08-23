require 'rails_helper'

RSpec.describe "expenses", type: :system do
  let(:user) { create(:user) }
  let(:location) { create(:location, user: user) }
  let!(:expense) { create(:expense, location: location, user: user) }
  let!(:expenses) { Array.new(2) { create(:expense, location: location, user: user) } }

  before do
    sign_in user
    visit location_expenses_path(location)
  end

  describe "index page" do
    it "出金一覧が全て表示されること" do
      expenses.all? do |expense|
        expect(page).to have_content(expense.expense_name)
        expect(page).to have_content(expense.expense_day.to_datetime.strftime('%Y/%m/%d'))
        expect(page).to have_content("#{expense.expense_money.to_s(:delimited)}円")
        
      end
    end

    context "リンクの表示について" do
      it "全てのリンクが表示されること" do
        expenses.each do |expense|
          expect(page).to have_link("新規作成", href: new_location_expense_path(location))
          expect(page).to have_link(href: location_expense_path(location, expense))
          expect(page).to have_link("編集", href: edit_location_expense_path(location, expense))
          expect(page).to have_link("削除", href: location_expense_path(location, expense))
        end
      end
    end
  end

  describe "new page" do
    before do
      visit new_location_expense_path(location)
    end

    it "フォームが表示されること" do
      expect(page).to have_selector("form")
    end

    it "戻るリンクが表示されること" do
      expect(page).to have_link("戻る")
    end

    it "出金が作成されること" do
      fill_in "出金名", with: "新しい出金"
      fill_in "出金日", with: Date.current
      fill_in "金額", with: 1000
      click_button "登録"
      expect(page).to have_content("新しい出金")
    end
  end

  describe "edit page" do
    before do
      visit edit_location_expense_path(location, expense)
    end

    context "編集ページの表示について" do
      it "出金名の編集欄が表示されること" do
        expect(page).to have_field("expense[expense_name]", with: expense.expense_name)
      end
      
      it "出金日の編集欄が表示されること" do
        expect(page).to have_field("expense[expense_day]", with: expense.expense_day)
      end

      it "金額の編集欄が表示されること" do
        expect(page).to have_field("expense[expense_money]", with: expense.expense_money.to_s)
      end

      it "出金日の編集欄が表示されること" do
        expect(page).to have_field("expense[expense_memo]", with: expense.expense_memo)
      end
    end

    it "戻るリンクが表示されること" do
      expect(page).to have_link("戻る")
    end

    it "出金が更新されること" do
      fill_in "出金名", with: "更新後の出金"
      click_button "更新"
      expect(page).to have_content("更新後の出金")
    end
  end

  describe "monthly expenses page" do
    before do
      visit monthly_expenses_location_expenses_path(location)
    end

    it "月次収出のグラフが表示されること" do
      expect(page).to have_selector(".monthly-container")
    end

    it "戻るリンクが表示されること" do
      expect(page).to have_link("戻る")
    end
  end
end
